#include "controllers_TestWithNativeLibrary.h"

JNIEXPORT void JNICALL Java_controllers_TestWithNativeLibrary_init(JNIEnv *env, jobject obj, jstring str)
{
}

JNIEXPORT void JNICALL Java_controllers_TestWithNativeLibrary_add_1vec(JNIEnv *env, jobject obj, jintArray x, jintArray y, jintArray z)
{
    unsigned int len = env->GetArrayLength(x);
    jint *xx = env->GetIntArrayElements(x, nullptr);
    jint *yy = env->GetIntArrayElements(y, nullptr);
    jint *zz = env->GetIntArrayElements(z, nullptr);
    for(unsigned int i = 0; i < len; i++){
        zz[i] = xx[i] + yy[i];
    }
    env->ReleaseIntArrayElements(x, xx, 0);
    env->ReleaseIntArrayElements(y, yy, 0);
    env->ReleaseIntArrayElements(z, zz, 0);
    return;
}

JNIEXPORT void JNICALL Java_controllers_TestWithNativeLibrary_clear(JNIEnv *, jobject)
{
}
