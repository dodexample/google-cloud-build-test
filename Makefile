project=dod-terraform-testing
bucket=$(project)-terraform-state
bootstrap:
	# https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/terraform/examples/gcs_backend
	# set project
	gcloud config set project $(project)
	# create bucket if necessary
	gsutil ls | grep $(bucket) || gsutil mb gs://$(bucket)
	# enabled cloudbuild for project
	for service in cloudbuild container ; do  \
		gcloud services list  |grep $${service}.googleapis.com || gcloud services enable $${service}.googleapis.com \
	; done
	# create terraform builder image
	if ! gcloud container images list | grep '/terraform$$' | grep terraform; then \
		export workspace=$$(mktemp -d); cleanup() { rm -rf $$workspace; }; trap cleanup EXIT; \
		cd $$workspace; \
		git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git; \
		cd cloud-builders-community/terraform; \
		gcloud builds submit --config=cloudbuild.yaml; \
	fi
	# TODO: add kubernetes service account role to cloudbuild service account ( should be easy )
	# TODO: create gcloud build hook from github automatically ( requires github access so I don't know if this can be 
	# completely automated
	# https://cloud.google.com/source-repositories/docs/integrating-with-cloud-build
