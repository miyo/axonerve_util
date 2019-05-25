#include "AxonerveKVS.h"
#include "axonerve_kvs.hpp"

using namespace Axonerve;

inline AxonerveKVS* instance(JNIEnv *env, jobject obj){
    jlong ptr;
    jclass cls = env->FindClass("AxonerveKVS");
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    ptr = env->GetLongField(obj, ptr_id);
    AxonerveKVS *k = (AxonerveKVS*)ptr;
    return k;
}

JNIEXPORT void JNICALL Java_AxonerveKVS_init(JNIEnv *env, jobject obj, jstring bin){
    const char *bin_c = env->GetStringUTFChars(bin, nullptr);
    AxonerveKVS *kvs = new AxonerveKVS(bin_c);
    jclass cls = env->FindClass("AxonerveKVS");
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    env->SetLongField(obj, ptr_id, (jlong)kvs);
    env->ReleaseStringUTFChars(bin, bin_c);
}

JNIEXPORT void JNICALL Java_AxonerveKVS_clear(JNIEnv *env, jobject obj){
    AxonerveKVS *kvs = instance(env, obj);
    delete(kvs);
}

JNIEXPORT void JNICALL Java_AxonerveKVS_reset(JNIEnv *env , jobject obj){
    AxonerveKVS *kvs = instance(env, obj);
    kvs->reset();
}

JNIEXPORT void JNICALL Java_AxonerveKVS_put(JNIEnv *env, jobject obj, jintArray k, jint v){
    int klen = env->GetArrayLength(k);
    jint *kk = env->GetIntArrayElements(k, nullptr);
    AxonerveKVS *kvs = instance(env, obj);
    unsigned int kkk[] = {kk[0], kk[1], kk[2], kk[3]};
    kvs->put(kkk, (unsigned int)v);
    env->ReleaseIntArrayElements(k, kk, 0);
    return;
}

JNIEXPORT jboolean JNICALL Java_AxonerveKVS_get(JNIEnv *env, jobject obj, jintArray k, jintArray v){
    int klen = env->GetArrayLength(k);
    int vlen = env->GetArrayLength(v);
    jint *kk = env->GetIntArrayElements(k, nullptr);
    jint *vv = env->GetIntArrayElements(v, nullptr);
    AxonerveKVS *kvs = instance(env, obj);
    unsigned int kkk[] = {kk[0], kk[1], kk[2], kk[3]};
    unsigned int vvv = 0;
    bool flag = kvs->get(kkk, vvv);
    vv[0] = vvv;
    env->ReleaseIntArrayElements(k, kk, 0);
    env->ReleaseIntArrayElements(v, vv, 0);
    return (jboolean)flag;
}

JNIEXPORT void JNICALL Java_AxonerveKVS_remove(JNIEnv *env, jobject obj, jintArray k){
    int klen = env->GetArrayLength(k);
    jint *kk = env->GetIntArrayElements(k, nullptr);
    AxonerveKVS *kvs = instance(env, obj);
    unsigned int kkk[] = {kk[0], kk[1], kk[2], kk[3]};
    kvs->remove(kkk);
    env->ReleaseIntArrayElements(k, kk, 0);
    return;
}
