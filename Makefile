blueprint: ## Generate all blueprints file
	@if ! type orbit >/dev/null 2>&1; then echo "Missing orbit dependency, please install from https://github.com/gulien/orbit/"; exit 1; fi
	orbit run generate
	@sed -i '1i\# DO NOT EDIT THIS FILE : Make yours changes in /utils/Dockerfile.*.blueprint)' Dockerfile.*
	@sed -i '1i\[DO NOT EDIT THIS FILE]: <> (Make yours changes in /utils/README.blueprint.md)' README.md

test-latest: test-php8.0 ## Test the latest build only

test-php8.1: blueprint ## Test php8.1 build only
	PHP_VERSION=8.1 BRANCH=v4 VARIANT=apache ./build-and-test.sh || (notify-send -u critical "Tests failed" && exit 1)
	PHP_VERSION=8.1 BRANCH=v4 VARIANT=cli ./build-and-test.sh || (notify-send -u critical "Tests failed" && exit 1)
	notify-send -u critical "Tests passed with success"

test-php8.0: blueprint ## Test php8.0 build only
	PHP_VERSION=8.0 BRANCH=v4 VARIANT=apache ./build-and-test.sh || (notify-send -u critical "Tests failed" && exit 1)
	PHP_VERSION=8.0 BRANCH=v4 VARIANT=cli ./build-and-test.sh || (notify-send -u critical "Tests failed" && exit 1)
	notify-send -u critical "Tests passed with success"

clean: ## Clean dangles image after build