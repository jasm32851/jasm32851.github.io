---
layout: post
title:  "Building Boost C++ Library on a Mac"
date:   2018-8-31
categories: jekyll update
---

[Boost is C++ library](https://www.boost.org/) that's widely used in science software, but it can be a pain to compile yourself, especially on a Mac.
The brew formula has given me (and others I've talked to) a bit of trouble and it is often better to compile yourself.
That being said, if you have a host of compilers and mpi wrappers, things get tricky pretty quick.
I hope the guide below helps you avoid some of the mistakes I've made and if you have any comments or suggestions how to make this guide more help, just shoot me an email!

<!--  -->

## Download
- This part is easy enough, you can find a slew of Boost versions on their [website](https://www.boost.org/) so just download one and unpack it (I usually do this in my `~/apps` directory).
  - In this guide, I use boost_1_67_0, but you can use any one you'd like, I include it here to show you exactly what the paths look like when I build Boost.

## Choose a compiler

### Apple LLVM without MPI
```bash
$ cd ~/apps/boost_1_67_0
$ ./bootstrap.sh --prefix=/Users/jets/apps/boost_1_67_0/stage
...
$ ./b2 -j4
```

The prefix flags (as `./bootstrap.sh --help` will tell you) specifies the path where the compiled Boost libraries will.
A directory named `stage` inside the main directory is the most popular location used in our group and that's what I'll use in this tutorial.
I've seen lots of other locations, e.g. `/usr/local/lib` and `/opt/boost`, but I think it's a good idea to keep the libraries of a particular Boost compiled in a directory that it doesn't share with anything else.
You may want to have several directories such as `~/apps/boost_1_67_0/stage_gcc` or `~/apps/boost_1_67_0/stage_icpc` that work with different compilers so you don't have to recompile Boost every time you switch compilers.
You can name the directory whatever you want as long as you know what's in it!

Now you want to append your `~/.bashrc` with the following:
```bash
export $PATH:/Users/jets/apps/boost_1_67_0:$PATH
export $LD_LIBRARY_PATH:/Users/jets/apps/boost_1_67_0/stage/lib:$LD_LIBRARY_PATH
```
With these you won't have to specify the paths to boost headers and libraries at compile time.

#### Bad Path ID
The first thing you want to do after you build Boost is test to make sure that everything built properly.
You can use an example from the [Boost](https://www.boost.org/) website if you like.
After you compile the test check the links with the following command `otool -L test_exe`.
If your output looks like the one below you're going to have problems because the serialization library path is not a valid absolute path and you won't be able to find it at run time.
```bash
bin.v2/libs/serialization/build/gcc-8.1.0/release/threading-multi/libboost_serialization.dylib
/usr/local/opt/gcc/lib/gcc/8/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.25.0)
/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.50.4)
/usr/local/lib/gcc/8/libgcc_s.1.dylib (compatibility version 1.0.0, current version 1.0.0)
```

We can correct this manually, by going to `/Users/jets/apps/boost_1_67_0/stage/lib` and setting the rpath the library ourselves.
For more details about install_name_tool see [here](https://www.unix.com/man-page/osx/1/install_name_tool/).

```bash
$ install_name_tool libboost_serialization.dylib -id /Users/jets/apps/boost_1_67_0/stage/lib/libboost_serialization.dylib
```

After we've done this, we can go back to the directory with our test, recompile, and check the links again to find:

```bash
/Users/jets/apps/boost_1_67_0/stage/lib/libboost_serialization.dylib (compatibility version 0.0.0, current version 0.0.0)
/usr/local/opt/gcc/lib/gcc/8/libstdc++.6.dylib (compatibility version 7.0.0, current version 7.25.0)
/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.50.4)
/usr/local/lib/gcc/8/libgcc_s.1.dylib (compatibility version 1.0.0, current version 1.0.0)
```

Everything looks good!

### Apple LLVM with MPI

This time we only add a small step after we run the `./bootstrap.sh` script.
At the end of you `project-config.jam` file add the following (_just as shown below, the spaces are important_):

```text
using mpi : mpicxx ;
```

After this, the rest of the procedure is the same as described above.


### Using non-native compilers
Whether you use, GCC, Intel, PGI, or other compilers most of these steps should be the same except you replace the mpi-wrapped compiler command with the one appropriate for your system. For this tutorial I will stick with GCC because that's what I use most of the time (it's easy to install with brew and comes with OpenMP support by default which the Apple compiler does _not_).

We need to change the `project-config.jam` again.
Where exactly you put this in the file doesn't matter, I usually put it near the beginning so it's one of the first things I see if I'm going back to see what I used to build Boost.

```text
using g++ : 8 ;
```

This tells Boost to look for the C++ compiler g++-8.
Brew installs shortcuts to the g++-8 compiler when you download it so you shouldn't need to specify an absolute path here.
If you want to use an MPI wrapped compiler, we do it just as described above, by adding the following:

```text
using mpi : mpicxx ;
```

Thanks for reading and if you running into any issues compiling Boost on your Mac or have suggestions about the guide you can contact me using one of the links below!
