include common.mk
source_root_dir = $(shell pwd)

$(source_root_dir)/node_modules/.bin/cspell:
	$(call cmd_ensure_exists,yarn)
	yarn install

.PHONY: spell-check
spell-check: $(source_root_dir)/node_modules/.bin/cspell
	yarn cspell --gitignore "**/*.adoc"