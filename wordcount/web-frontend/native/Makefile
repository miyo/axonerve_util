CXXFLAGS = -O2 -Wall
JNI_INCLUDE = -I/usr/lib/jvm/java-11-openjdk-amd64/include/ -I/usr/lib/jvm/java-11-openjdk-amd64/include/linux/

libtest_with_native_library_jni.so: test_with_native_library_jni.cpp
	g++ $(CXXFLAGS) -shared -fPIC $(JNI_INCLUDE) -o "$@" -Wl,-soname,$@ $^ -lstdc++

clean:
	-rm -f libtest_with_native_library_jni.so
