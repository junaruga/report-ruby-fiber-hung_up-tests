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

```
$ git clone https://github.com/ruby/ruby.git
$ cd ruby
```

```
$ bash ./test.sh 2>&1 | tee test.log
...
+ make -s test-all RUBYOPT=-w
...
[903/903] 3361306=test_numeric




Retrying hung up testcases...
[1/2] TestFiberQueue#test_pop_with_timeout^C
...
```

When I opened another terminal, and checked processes, the result was below.
The `TestFiberQueue#test_pop_with_timeout` is hung up.

```
$ ps -wwef
...
jaruga   3360611 3304021  0 19:26 pts/1    00:00:00 make -s test-all RUBYOPT=-w
jaruga   3361303 3360611  2 19:26 pts/1    00:00:09 /home/jaruga/git/ruby/ruby/build/ruby --disable-gems ../test/runner.rb --ruby=./miniruby -I../lib -I. -I.ext/common  ../tool/runruby.rb --extout=.ext  -- --disable-gems --excludes-dir=../test/.excludes --name=!/memory_leak/ -j9 -q --tty=no
jaruga   3361312 3361303 27 19:26 pts/1    00:01:44 /home/jaruga/git/ruby/ruby/tool/lib/test/unit/parallel.rb: TestFiberQueue#test_pop_with_timeout
```
