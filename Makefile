
# ------------------------------------------------------------------------------
# Variables
# NAMESPACE is your OpenWhisk namespace. Default to last item in `wsk namespace list`
# PACKAGE is the OpenWhisk package that our actions live in
NAMESPACE = $(shell wsk namespace list | tail -n1)
PACKAGE=AlexaBinDay

# list of actions to build
ACTIONS = BinDay

ZIPS=$(ACTIONS:%=build/%.zip)
GIT_HASH=$(shell git rev-parse HEAD)



# ------------------------------------------------------------------------------
.PHONY: all upload curl
all: $(ZIPS)

# force an upload to OpenWhisk
upload: $(ZIPS)
	./updateAction.sh $(PACKAGE) $?


# build an action's zip file from it's action directory
build/%.zip: actions/%.swift actions/common/*
	@cat actions/common/*.swift actions/$(@F:.zip=).swift > build/$(@F:.zip=).swift
	./compile.sh $(@F:.zip=)
	./updateAction.sh $(PACKAGE) $@

# make curl action={name} args="foo=bar"
curl: $(ZIPS)
	$(eval HOST := $(shell wsk property get --apihost | awk '{printf("%s", $$4)}'))
	curl -k https://$(HOST)/api/v1/web/$(NAMESPACE)/$(PACKAGE)/$(action)?$(args) | jq -S

test:
	$(eval HOST := $(shell wsk property get --apihost | awk '{printf("%s", $$4)}'))
	 curl -i -X POST -H "Content-Type: application/json" -d @test_payload.json "https://$(HOST)/api/v1/web/$(NAMESPACE)/$(PACKAGE)/BinDay.json"

# ------------------------------------------------------------------------------
# Misc targets
.PHONY: lastlog setup clean distclean

lastlog:
	wsk activation list -l1 | tail -n1 | cut -d ' ' -f1 | xargs wsk activation logs

setup:
	# Create package
	wsk package update $(PACKAGE) --param-file parameters.json

clean:
	rm -rf build/*.swift
	rm -rf build/*.zip

distclean: clean
	./deleteActions.sh $(PACKAGE) $(ACTIONS)
	wsk package delete $(PACKAGE)
