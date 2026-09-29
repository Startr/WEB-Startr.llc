# startr.llc — one static page in public/, deployed to Cloudflare Pages.
# `make check` must pass before `make deploy`.

# 1. help (default target)
help:
	@echo "================================================"
	@echo "       $(OWNER)/$(PROJECT_NAME) by Startr.Cloud"
	@echo "================================================"
	@echo "This is the default make command."
	@echo "This command lists available make commands."
	@echo ""
	@echo "Usage example:"
	@echo "    make it_run"
	@echo ""
	@echo "Available make commands:"
	@echo ""
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | \
		awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ { \
		if ($$1 !~ "^[#.]") {print $$1}}' | \
		sort | \
		grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo ""

# 2. Dynamic variable extraction (mirrors startr.sh)
PROJECTPATH := $(shell git rev-parse --show-toplevel)
PROJECT     := $(shell echo $$(basename $(PROJECTPATH)) | tr '[:upper:]' '[:lower:]')
# Use symbolic-ref (clean failure on empty repos) → short SHA (detached HEAD) → develop fallback.
# Do NOT use `git rev-parse --abbrev-ref HEAD` — it prints "HEAD" to stdout AND fails on a
# no-commits repo, producing a corrupted "HEAD develop" value.
FULL_BRANCH := $(shell git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "develop")
BRANCH      := $(shell echo $(FULL_BRANCH) | sed 's/.*\///' | tr '[:upper:]' '[:lower:]')
TAG         := $(shell git describe --always --tag 2>/dev/null || echo "v0.0.0")

# Owner and project name extracted from git remote URL
REMOTE_URL   := $(shell git config --get remote.origin.url 2>/dev/null || echo "unknown/unknown")
OWNER        := $(shell echo $(REMOTE_URL) | sed -E 's|.*[:/]([^/]+)/[^/]+(.git)?$$|\1|')
PROJECT_NAME := $(shell echo $(REMOTE_URL) | sed -E 's|.*[:/][^/]+/([^/]+)(.git)?$$|\1|' | sed 's/\.git$$//')

# Container name (used by Docker block if present)
CONTAINER := $(PROJECT)-$(BRANCH)

# 3. Load environment overrides from .env if present
-include .env

# 4. Project-specific targets
# Cloudflare Pages names allow only lowercase letters, digits and dashes, so
# the Pages project cannot reuse PROJECT_NAME (WEB-Startr.llc).
PAGES_PROJECT ?= startr-llc
PORT ?= 8090
SELF ?= https://startr.llc
# The design renders need puppeteer; this repo keeps no node_modules of its own.
PUPPETEER_NODE_PATH ?= $(HOME)/Documents/Projects/GitHub/WEB-Sage.is/node_modules

it_run:  # Serve public/ locally at http://localhost:$(PORT)
	python3 -m http.server $(PORT) --directory public

favicon:  # Render the S monogram master for the small icons
	NODE_PATH=$(PUPPETEER_NODE_PATH) node design/render-favicon.cjs

icons:  # Regenerate every icon from the logo and the monogram master
	./design/make-icons.sh

social:  # Render the 1200x630 link-preview card
	NODE_PATH=$(PUPPETEER_NODE_PATH) node design/render-social.cjs

check:  # Every link, asset and icon the page names must answer 200 or exist locally
	@# External URLs are fetched. URLs on this site itself cannot answer before
	@# the first deploy, so they are mapped to files under public/ instead,
	@# along with root-relative paths and the manifest's icons.
	@fail=0; page=public/index.html; \
	for u in $$(grep -oE '(href|src|srcset|content)="https://[^"]+"|url\(.https://[^)]+\)' $$page \
	           | grep -oE 'https://[^"'"'"')]+' | grep -v '^$(SELF)' | sort -u); do \
	  code=$$(curl -s -o /dev/null -m 15 -w '%{http_code}' "$$u"); \
	  if [ "$$code" = "200" ]; then echo "  ok   $$u"; else echo "  FAIL $$code $$u"; fail=1; fi; \
	done; \
	for f in $$( { grep -oE '(href|src|srcset)="/[^"]+"' $$page | grep -oE '/[^"]+'; \
	               grep -oE '$(SELF)/[^"'"'"' )]*' $$page | sed 's#^$(SELF)##'; \
	               grep -oE '"src": *"/[^"]+"' public/site.webmanifest | grep -oE '/[^"]+'; } | sort -u ); do \
	  p="public$$f"; [ "$$f" = "/" ] && p=public/index.html; \
	  if [ -f "$$p" ]; then echo "  ok   $$p"; else echo "  FAIL missing $$p"; fail=1; fi; \
	done; \
	exit $$fail

deploy: check  # Upload public/ to Cloudflare Pages (needs wrangler login)
	bunx wrangler pages deploy public --project-name $(PAGES_PROJECT)

# 8. show_vars + verify
show_vars:
	@echo "=== Dynamic Variables ==="
	@echo "PROJECTPATH=$(PROJECTPATH)"
	@echo "PROJECT=$(PROJECT)"
	@echo "OWNER=$(OWNER)"
	@echo "PROJECT_NAME=$(PROJECT_NAME)"
	@echo "FULL_BRANCH=$(FULL_BRANCH)"
	@echo "BRANCH=$(BRANCH)"
	@echo "TAG=$(TAG)"
	@echo "CONTAINER=$(CONTAINER)"
	@echo "REMOTE_URL=$(REMOTE_URL)"
	@echo ""

# One-shot scaffold self-check. Bundles every read-only verification into a
# single make invocation so post-scaffold testing isn't N separate processes.
verify: show_vars require_gitflow_next
	@echo "=== Targets defined in this Makefile ==="
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | \
		awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ { \
		if ($$1 !~ "^[#.]") {print "  " $$1}}' | \
		sort -u | \
		grep -E -v -e '^  [^[:alnum:]]'
	@echo ""
	@echo "OK: Makefile scaffold verified."

# 9. Git-flow-next release/hotfix flow
require_gitflow_next:
	@if ! git flow version 2>/dev/null | grep -q 'git-flow-next'; then \
		echo "Error: git-flow-next required (Go rewrite). Install: brew install git-flow-next"; \
		exit 1; \
	fi

minor_release: require_gitflow_next
	# Start a minor release with incremented minor version
	git flow release start $$(git tag --sort=-v:refname | sed 's/^v//' | head -n 1 | awk -F'.' '{print $$1"."$$2+1".0"}') && echo "or use 'make release_finish' to finish the release"

patch_release: require_gitflow_next
	# Start a patch release with incremented patch version
	git flow release start $$(git tag --sort=-v:refname | sed 's/^v//' | head -n 1 | awk -F'.' '{print $$1"."$$2"."$$3+1}') && echo "or use 'make release_finish' to finish the release"

major_release: require_gitflow_next
	# Start a major release with incremented major version
	git flow release start $$(git tag --sort=-v:refname | sed 's/^v//' | head -n 1 | awk -F'.' '{print $$1+1".0.0"}') && echo "or use 'make release_finish' to finish the release"

hotfix: require_gitflow_next
	# Start a hotfix with incremented n.n.n.n version (incrementing the fourth number)
	git flow hotfix start $$(git tag --sort=-v:refname | sed 's/^v//' | head -n 1 | awk -F'.' '{print $$1"."$$2"."$$3"."$$4+1}') && echo "or use 'make hotfix_finish' to finish the hotfix"

release_finish: require_gitflow_next
	git flow release finish && git push origin develop && git push origin master && git push --tags && git checkout develop

hotfix_finish: require_gitflow_next
	git flow hotfix finish && git push origin develop && git push origin master && git push --tags && git checkout master

# 10. things_clean
things_clean:
	git clean --exclude='!.env*' -Xdf

# 11. .PHONY
.PHONY: help show_vars verify require_gitflow_next \
	minor_release patch_release major_release hotfix \
	release_finish hotfix_finish things_clean \
	it_run favicon icons social check deploy
