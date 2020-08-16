.PHONY: css clean requirements create_environment

#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROJECT_NAME = bikeGarage
PYTHON_INTERPRETER = python3
VENV_PATH = ~/.virtualenvs/stravadb/

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

## Install Python Dependencies
requirements:
	source $(VENV_PATH)/bin/activate \
	pip install -U pip setuptools wheel \
	pip install -r requirements.txt


#################################################################################
# PROJECT TARGETS                                                               #
#################################################################################

## Install all required static files
css: bootstrap theme_css

## Download and install bootstrap css
bootstrap:
	curl -L https://github.com/twbs/bootstrap/releases/download/v4.5.0/bootstrap-4.5.0-dist.zip -o /tmp/bootstrap_files.zip
	unzip /tmp/bootstrap_files.zip -d /tmp/bootstrap_files
	cp -r /tmp/bootstrap_files/bootstrap-4.5.0-dist bikeGarage/static
	curl https://code.jquery.com/jquery-3.3.1.slim.min.js -o bikeGarage/static/js/jquery-3.3.1.slim.min.js

## Download and install theme css
theme_css:
	mkdir bikeGarage/static/scss
	curl https://bootswatch.com/4/superhero/bootstrap.min.css -o bikeGarage/static/css/bootstrap.min.css
	curl https://bootswatch.com/4/superhero/bootstrap.css -o bikeGarage/static/css/bootstrap.css
	curl https://bootswatch.com/4/superhero/_variables.scss -o bikeGarage/static/scss/_variables.scss
	curl https://bootswatch.com/4/superhero/_bootswatch.scss -o bikeGarage/static/scss/_bootswatch.scss

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
