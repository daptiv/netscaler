# CHANGELOG for netscaler

This file is used to list changes made in each version of netscaler.

## 0.0.14
- Feature: new monitor resource/provider

## 0.0.12
- Hotfix: remove vendored gem as it causes `berks upload` failure
- Now just loading gem to system in begin - rescue block, much simpler

## 0.0.11
- Hotfix: vendor rest-client gem since it was pulled from Chef as a dep
- Removed tailor from rakefile and added rubocop
- Fixed a few minor rubocop issues
- Version bump

## 0.0.10
- Feature: save appliance configuration, logout

## 0.0.9
- Bug Fix: binding now binds all servers to servicegroups instead of just the first

## 0.0.8
- Better exception handling

## 0.0.7
- Bug Fix: find_primary method breaks when password has '@' symbol.

## 0.0.6
- Version bump
- Updated logging
- Find_primary method should just convert to array if string instead of big if/else
- Use .to_sym method instead of string interpolation
- Updated 'If' and 'unless' blocks to be more succinct
- Renamed resource1/2 to primary/secondary_resource
- Separated logic for key value check into own method
- Updated README to reflect refactor

## 0.0.5
Add missing matcher for :bind action.

## 0.0.4
Refactor check methods to be more ruby-like.

## 0.0.3
Support for binding servers to service groups.

## 0.0.2:
Support for HA.

## 0.0.1:
Initial version.
- - - 
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
