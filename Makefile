.PHONY: build test benchmark publish

build:
	gem build lightstep.gemspec

test:
	bundle exec rake spec
	ruby example.rb
	ruby examples/fork_children/main.rb

benchmark:
	ruby benchmark/bench.rb
	ruby benchmark/threading/thread_test.rb

bump-version:
	ruby -e 'require "bump"; Bump::Bump.run("patch")'
	make build	# rebuild after version increment
	git tag `ruby scripts/version.rb`
	git push
	git push --tags

publish: build test benchmark bump-version
	gem push lightstep-`ruby scripts/version.rb`.gem
