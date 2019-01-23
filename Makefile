run:
	bundle exec foreman start

debug:
	bundle exec bin/rails console

test:
	RAILS_ENV=test bundle exec rspec --fail-fast

.PHONY: doc
doc:
	bundle exec yard doc --quiet

.PHONY: doc_stats
doc_stats:
	bundle exec yard stats --list-undoc
