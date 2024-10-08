add_custom_target(libc_pthread_unittests)

add_libc_unittest(
  pthread_attr_test
  SUITE
    libc_pthread_unittests
  SRCS
    pthread_attr_test.cpp
  DEPENDS
    libc.include.pthread
    libc.src.pthread.pthread_attr_destroy
    libc.src.pthread.pthread_attr_init
    libc.src.pthread.pthread_attr_getdetachstate
    libc.src.pthread.pthread_attr_getguardsize
    libc.src.pthread.pthread_attr_getstacksize
    libc.src.pthread.pthread_attr_getstack
    libc.src.pthread.pthread_attr_setdetachstate
    libc.src.pthread.pthread_attr_setguardsize
    libc.src.pthread.pthread_attr_setstacksize
    libc.src.pthread.pthread_attr_setstack
    libc.hdr.errno_macros
)

add_libc_unittest(
  pthread_mutexattr_test
  SUITE
    libc_pthread_unittests
  SRCS
    pthread_mutexattr_test.cpp
  DEPENDS
    libc.include.pthread
    libc.src.pthread.pthread_mutexattr_destroy
    libc.src.pthread.pthread_mutexattr_init
    libc.src.pthread.pthread_mutexattr_getpshared
    libc.src.pthread.pthread_mutexattr_getrobust
    libc.src.pthread.pthread_mutexattr_gettype
    libc.src.pthread.pthread_mutexattr_setpshared
    libc.src.pthread.pthread_mutexattr_setrobust
    libc.src.pthread.pthread_mutexattr_settype
    libc.hdr.errno_macros
)

add_libc_unittest(
  pthread_condattr_test
  SUITE
    libc_pthread_unittests
  SRCS
    pthread_condattr_test.cpp
  DEPENDS
    libc.include.llvm-libc-macros.generic_error_number_macros
    libc.include.llvm-libc-macros.time_macros
    libc.include.pthread
    libc.src.pthread.pthread_condattr_destroy
    libc.src.pthread.pthread_condattr_getclock
    libc.src.pthread.pthread_condattr_getpshared
    libc.src.pthread.pthread_condattr_init
    libc.src.pthread.pthread_condattr_setclock
    libc.src.pthread.pthread_condattr_setpshared
)

add_libc_unittest(
  pthread_rwlockattr_test
  SUITE
    libc_pthread_unittests
  SRCS
    pthread_rwlockattr_test.cpp
  DEPENDS
    libc.include.pthread
    libc.src.errno.errno
    libc.src.pthread.pthread_rwlockattr_destroy
    libc.src.pthread.pthread_rwlockattr_getkind_np
    libc.src.pthread.pthread_rwlockattr_getpshared
    libc.src.pthread.pthread_rwlockattr_init
    libc.src.pthread.pthread_rwlockattr_setkind_np
    libc.src.pthread.pthread_rwlockattr_setpshared
)
