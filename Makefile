
build-docker:
	docker build -t adobeapiplatform/mocka . --no-cache
	docker tag adobeapiplatform/mocka adobeapiplatform/mocka:latest

run-tests:
	./run_unit_tests.sh

build-and-test: build-docker run-tests