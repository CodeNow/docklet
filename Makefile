build:
	@./node_modules/.bin/coffee -m -o lib src
test:
ifdef grep
		@NODE_ENV=testing ./node_modules/.bin/mocha --reporter spec --grep ${grep}
else
		@NODE_ENV=testing ./node_modules/.bin/mocha --reporter spec
endif
install:
	@npm install
start:
	@node server.js
coverage:
	@jscoverage lib lib-cov; rm -rf lib; mv lib-cov lib; mkdir ./coverage; ./node_modules/.bin/mocha -t 10000 --reporter html-cov > ./coverage/index.html
clean:
	@rm -rf ./lib; rm -rf ./coverage

.PHONY: test
.PHONY: install
.PHONY: build
.PHONY: image
.PHONY: watch
.PHONY: testwatch
.PHONY: coverage
.PHONY: clean
.PHONY: start
