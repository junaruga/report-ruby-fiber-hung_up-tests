# report-ruby-fiber-hung_up-tests

This repository is for the issue [ruby/ruby#3839](https://github.com/ruby/ruby/pull/8739).

Login to the RubyCI ppc64le server.

```
$ grep ^VERSION /etc/os-release
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy

$ gcc-11 --version
gcc-11 (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

Get the source. I was abled to confirm this issue on the latest ruby master branch `4aee6931c35a80af846f7100cb8aa1525618e580`.

```
$ git clone https://github.com/ruby/ruby.git
$ cd ruby
```

The tests are hung up. I typed Ctrl+C to stop the process.

```
$ bash ./test.sh 2>&1 | tee test.log
...
+ make -s test-all TESTS=../test/fiber/test_queue.rb RUBYOPT=-w
generating enc.mk
making enc
making srcs under enc
generating transdb.h
transdb.h unchanged
making trans
making encs
generating makefiles ext/configure-ext.mk
ext/configure-ext.mk updated
generating makefile exts.mk
exts.mk unchanged
linking shared-object -test-/array/resize.so
Run options:
  --seed=47121
  "--ruby=./miniruby -I../lib -I. -I.ext/common  ../tool/runruby.rb --extout=.ext  -- --disable-gems"
  --excludes-dir=../test/.excludes
  --name=!/memory_leak/
  -j9
  -q
  --tty=no

# Running tests:

[1/1] 3507820=test_queue
^C
^C
...
```

When I opened another terminal, and checked processes, the result was below.
The `TestFiberQueue#test_pop_with_timeout` is hung up.

```
$ ps -wwef | grep jaruga | grep ruby
jaruga   3507817 3507484  0 20:04 pts/1    00:00:00 /home/jaruga/git/ruby/ruby/build/ruby --disable-gems ../test/runner.rb --ruby=./miniruby -I../lib -I. -I.ext/common  ../tool/runruby.rb --extout=.ext  -- --disable-gems --excludes-dir=../test/.excludes --name=!/memory_leak/ -j9 -q --tty=no ../test/fiber/test_queue.rb
jaruga   3507820 3507817 18 20:04 pts/1    00:00:20 /home/jaruga/git/ruby/ruby/tool/lib/test/unit/parallel.rb: TestFiberQueue#test_pop_with_timeout
jaruga   3507988 3259113  0 20:06 pts/0    00:00:00 grep ruby
```
