#include "AxonerveWordcount.h"
#include "axonerve_wordcount.hpp"

using namespace Axonerve;

inline AxonerveWordcount* instance(JNIEnv *env, jobject obj){
    jlong ptr;
    jclass cls = env->FindClass("AxonerveWordcount");
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    ptr = env->GetLongField(obj, ptr_id);
    AxonerveWordcount *k = (AxonerveWordcount*)ptr;
    return k;
}

JNIEXPORT void JNICALL Java_AxonerveWordcount_init(JNIEnv *env, jobject obj, jstring bin){
    const char *bin_c = env->GetStringUTFChars(bin, nullptr);
    AxonerveWordcount *wordcount = new AxonerveWordcount(bin_c);
    jclass cls = env->FindClass("AxonerveWordcount");
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    env->SetLongField(obj, ptr_id, (jlong)wordcount);
    env->ReleaseStringUTFChars(bin, bin_c);
}

JNIEXPORT void JNICALL Java_AxonerveWordcount_close(JNIEnv *env, jobject obj){
    AxonerveWordcount *wordcount = instance(env, obj);
    delete(wordcount);
}

JNIEXPORT void JNICALL Java_AxonerveWordcount_reset(JNIEnv *env , jobject obj){
    AxonerveWordcount *wordcount = instance(env, obj);
    wordcount->reset();
}

JNIEXPORT void JNICALL Java_AxonerveWordcount_doWordCount(JNIEnv *env, jobject obj, jcharArray words){
    int wlen = env->GetArrayLength(words) / 16;
    jchar *w = env->GetCharArrayElements(words, nullptr);
    AxonerveWordcount *wordcount = instance(env, obj);
    std::vector<Word, aligned_allocator<Word>> buf(wlen);
    for(unsigned int i = 0; i < wlen; i++){
        for(int j = 0; j < 16; j++){
            buf[i].w[j] = *w;
            w++;
        }
    }
    wordcount->doWordCount(buf);
    env->ReleaseCharArrayElements(words, w, 0);
    return;
}

JNIEXPORT void JNICALL Java_AxonerveWordcount_getResult(JNIEnv *env, jobject obj, jintArray addr, jintArray value){
    int len = env->GetArrayLength(addr);
    jint *a = env->GetIntArrayElements(addr, nullptr);
    jint *v = env->GetIntArrayElements(value, nullptr);
    AxonerveWordcount *wordcount = instance(env, obj);
    std::vector<Result, aligned_allocator<Result>> buf(len);
    wordcount->getResult(buf);
    for(int i = 0; i < len; i++){
        a[i] = buf[i].addr;
        v[i] = buf[i].value;
    }
    env->ReleaseIntArrayElements(addr, a, 0);
    env->ReleaseIntArrayElements(value, v, 0);
    return;
}

JNIEXPORT void JNICALL Java_AxonerveWordcount_clear(JNIEnv *env, jobject obj){
    AxonerveWordcount *wordcount = instance(env, obj);
    wordcount->clear();
    return;
}
