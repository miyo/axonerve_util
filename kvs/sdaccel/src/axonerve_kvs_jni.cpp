#include "AxonerveKVS.h"

inline AxonerveKvs* instance(JNIEnv *env, jobject o){
    jlong ptr;
    jclass cls = env->FindClass("AxonerveKVS");
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    ptr = env->GetLongField(o, ptr_id);
    Test *t = (Test*)ptr;
    return t;
}

JNIEXPORT void JNICALL Java_Hoge_clear(JNIEnv *env, jobject o){
    Test *t = instance(env, o);
    delete(t);
}

JNIEXPORT void JNICALL Java_Hoge_print_1array(JNIEnv *env, jobject o, jintArray a){
}

JNIEXPORT void JNICALL Java_AxonerveKVS_remove(JNIEnv *, jobject);

/*
 * Class:     AxonerveKVS
 * Method:    clear
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_AxonerveKVS_clear
  (JNIEnv *, jobject);

JNIEXPORT void JNICALL Java_AxonerveKVS_put(JNIEnv *env, jobject obj, jintArray k, jint v){
    int klen = env->GetArrayLength(k);
    jint *kk = env->GetIntArrayElements(k, nullptr);
    AxonerveKVS *kvs = instance(env, obj);
    bool flag = kvs->get({kk[0], kk[1], kk[2], kk[3]}, v);
    env->ReleaseIntArrayElements(k, kk, 0);
    return;
}

JNIEXPORT jboolean JNICALL Java_AxonerveKVS_get(JNIEnv *env, jobject obj, jintArray k, jintArray v){
    int klen = env->GetArrayLength(k);
    int vlen = env->GetArrayLength(v);
    jint *kk = env->GetIntArrayElements(k, nullptr);
    jint *vv = env->GetIntArrayElements(v, nullptr);
    AxonerveKVS *kvs = instance(env, obj);
    bool flag = kvs->get({kk[0], kk[1], kk[2], kk[3]}, vv);
    env->ReleaseIntArrayElements(k, kk, 0);
    env->ReleaseIntArrayElements(v, vv, 0);
    return (jboolean)flag;
}

JNIEXPORT void JNICALL Java_AxonerveKVS_init(JNIEnv *env, jobject obj){
    AxonerveKVS *o = new AxonerveKVS();
    jclass cls = env->FindClass("AxonerveKVS");
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    env->SetLongField(obj, ptr_id, (jlong)t);
}

