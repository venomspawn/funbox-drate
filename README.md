# Solution to `dollar's rate` problem

This project contains solution to `dollar's rate` test problem from FunBox's
test case. The following technologies are used:

*   [Ruby](https://www.ruby-lang.org/en/) as main programming language;
*   [Puma](https://github.com/puma/puma) as HTTP-server;
*   [Rails](https://github.com/rails/rails) as a web-application framework;
*   [RSpec](https://github.com/rspec/rspec) for tests definitions and
    launching.

Names of all used libaries can be found in `Gemfile` of the project.

## Usage

### Provisioning and initial setup

Although it's not required, it's highly recommended to use the project in a
virtual machine. The project provides `Vagrantfile` to automatically deploy and
provision virtual machine with use of [VirtualBox](https://www.virtualbox.org/)
and [vagrant](https://www.vagrantup.com/) tool. One can use `vagrant up` in the
root directory of the cloned project to launch virtual machine and `vagrant
ssh` to enter it after boot. The following commands should be of use in the
terminal of virtual machine:

*   `bundle install` — install required libraries used by the project;
*   `make debug` — launch debug console application;
*   `make test` — run tests;
*   `make run` — launch service in development mode.

### Interface

The solution provides very simple web-interface, that can be accessed in a
web-browser by typing `localhost:8080` in its address bar after service launch.

## Deviations

The solution has a couple of deviations from the requirements mentioned in the
test case. It uses very small amount of JavaScript code for EventStream support
and doesn't use any of JavaScript libraries (though using one is recommended by
the case). The other deviation needed to mention concludes from the following:
*   the case requires to use date-time field in admin page;
*   the case requires to use Chrome _and_ Firefox of latest versions;
*   the only native not-obsolete type for input with both date _and_ time
    support is `datetime-local`;
*   even latest versions of Firefox don't support `datetime-local` type of
    input fields.

As a result admin page uses _two_ fields instead of one: one for date, one for
time. Two fields bring two parameters to work with in request processing on the
rate submit.

Both of these deviations could be easily solved with greatly increased amount
of JavaScript on frontend, but the test case is for _backend_ programmers, not
for _frontend_ ones.

## Documentation

The project uses in-code documentation in [`yard`](https://yardoc.org) format.
One can invoke `make doc` command to translate the documentation to HTML (it
will appear in `doc` directory in the project).
