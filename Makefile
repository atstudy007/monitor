THEME = $(HOME)/.spm/themes/arale
PROJ_ROOT=$(CURDIR)


build:
	@spm build
	@googlecc ${PROJ_ROOT}/src/seer-monitor.js ${PROJ_ROOT}/dist/seer-monitor.js
	@googlecc ${PROJ_ROOT}/src/seer-jsniffer.js ${PROJ_ROOT}/dist/seer-jsniffer.js
	@cat ${PROJ_ROOT}/dist/seer-monitor.js > ${PROJ_ROOT}/dist/seer.js
	@cat ${PROJ_ROOT}/dist/seer-jsniffer.js >> ${PROJ_ROOT}/dist/seer.js
	@rm ${PROJ_ROOT}/dist/seer-monitor.js ${PROJ_ROOT}/dist/seer-jsniffer.js
	@cat ${PROJ_ROOT}/src/seer-monitor.js > ${PROJ_ROOT}/dist/seer-debug.js
	@cat ${PROJ_ROOT}/src/seer-jsniffer.js >> ${PROJ_ROOT}/dist/seer-debug.js

build-doc:
	@nico build -v -C $(THEME)/nico.js

debug:
	@nico server -C $(THEME)/nico.js --watch debug

publish:
	@spm publish -s alipay

server:
	@nico server -C $(THEME)/nico.js

watch:
	@nico server -C $(THEME)/nico.js --watch

publish-doc: clean build-doc
	@rm -fr _site/sea-modules
	@spm publish --doc _site -s alipay

publish-pages: clean build-doc
	@ghp-import _site
	@git push origin gh-pages

clean:
	@rm -fr _site


reporter = spec
url = tests/runner.html
test:
	@mocha-phantomjs --reporter=${reporter} http://127.0.0.1:8000/${url}

coverage:
	@rm -fr _site/src-cov
	@jscoverage --encoding=utf8 src _site/src-cov
	@$(MAKE) test reporter=json-cov url=tests/runner.html?coverage=1 | node $(THEME)/html-cov.js > tests/coverage.html
	@echo "Build coverage to tests/coverage.html"


.PHONY: build-doc debug server publish clean test coverage
