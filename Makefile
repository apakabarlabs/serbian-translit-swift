PYTHON_DATA_DIR = ../serbian-translit-python/serbian_translit/data
PYTHON_TESTS_DIR = ../serbian-translit-python/tests
SWIFT_RESOURCES_DIR = Sources/SerbianTranslit/Resources
SWIFT_TEST_RESOURCES_DIR = Tests/SerbianTranslitTests/Resources

.PHONY: build test docs lint lint-fix clean install sync-yaml

build:
	swift build

test:
	swift test

docs:
	swift package --allow-writing-to-directory .build/docc generate-documentation \
		--target SerbianTranslit --output-path .build/docc \
		--warnings-as-errors \
		--transform-for-static-hosting \
		--hosting-base-path serbian-translit-swift

lint:
	swiftlint

lint-fix:
	swiftlint --fix

clean:
	swift package clean
	rm -rf .build Package.resolved

install:
	brew install swiftlint

sync-yaml:
	cp $(PYTHON_DATA_DIR)/rules.yaml $(SWIFT_RESOURCES_DIR)/
	cp $(PYTHON_TESTS_DIR)/tests.yaml $(SWIFT_TEST_RESOURCES_DIR)/
