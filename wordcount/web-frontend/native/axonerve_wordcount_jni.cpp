#include "controllers_AxonerveWordcount.h"
#include "axonerve_wordcount.hpp"

#include <iostream>

using namespace Axonerve;

inline AxonerveWordcount* instance(JNIEnv *env, jobject obj){
    jlong ptr;
    jclass cls = env->FindClass("controllers/AxonerveWordcount");
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    ptr = env->GetLongField(obj, ptr_id);
    AxonerveWordcount *k = (AxonerveWordcount*)ptr;
    return k;
}

JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_init(JNIEnv *env, jobject obj, jstring bin){
    std::cout << "Java_controllers_AxonerveWordcount_init" << std::endl;
    const char *bin_c = env->GetStringUTFChars(bin, nullptr);
    std::cout << " make wordcount instance" << std::endl;
    AxonerveWordcount *wordcount = new AxonerveWordcount(bin_c);
    std::cout << " find class" << std::endl;
    jclass cls = env->FindClass("controllers/AxonerveWordcount");
    std::cout << " get field id" << std::endl;
    jfieldID ptr_id = env->GetFieldID(cls, "ptr", "J");
    std::cout << " set instance pointer to the found field id" << std::endl;
    env->SetLongField(obj, ptr_id, (jlong)wordcount);
    std::cout << " release string value" << std::endl;
    env->ReleaseStringUTFChars(bin, bin_c);
    std::cout << "end" << std::endl;
}

JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_close(JNIEnv *env, jobject obj){
    AxonerveWordcount *wordcount = instance(env, obj);
    delete(wordcount);
}

JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_reset(JNIEnv *env , jobject obj){
    AxonerveWordcount *wordcount = instance(env, obj);
    wordcount->reset();
}

JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_doWordCount(JNIEnv *env, jobject obj, jbyteArray words){
    std::cout << "Java_controllers_AxonerveWordcount_doWordCount" << std::endl;
    int wlen = env->GetArrayLength(words) / 16;
    jbyte *w = env->GetByteArrayElements(words, nullptr);
    std::cout << "  get instance pointer" << std::endl;
    AxonerveWordcount *wordcount = instance(env, obj);
    std::cout << "  allocate working memory" << std::endl;
    std::vector<Word, aligned_allocator<Word>> buf(wlen);
    std::cout << "  copy data" << std::endl;
    for(unsigned int i = 0; i < wlen; i++){
        for(int j = 0; j < 16; j++){
            buf[i].w[j] = w[16*i+j];
        }
    }
    std::cout << "  run" << std::endl;
    wordcount->doWordCount(buf);
    std::cout << "  release" << std::endl;
    env->ReleaseByteArrayElements(words, w, 0);
    std::cout << "end" << std::endl;
    return;
}

JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_getResult(JNIEnv *env, jobject obj, jintArray addr, jintArray value){
    std::cout << "Java_controllers_AxonerveWordcount_getResult" << std::endl;
    int len = env->GetArrayLength(addr);
    jint *a = env->GetIntArrayElements(addr, nullptr);
    jint *v = env->GetIntArrayElements(value, nullptr);
    std::cout << "  get instance pointer" << std::endl;
    AxonerveWordcount *wordcount = instance(env, obj);
    std::cout << "  allocate working memory" << std::endl;
    std::vector<Result, aligned_allocator<Result>> buf(len);
    std::cout << "  run" << std::endl;
    wordcount->getResult(buf);
    std::cout << "  copy data" << std::endl;
    for(int i = 0; i < len; i++){
        a[i] = buf[i].addr;
        v[i] = buf[i].value;
    }
    std::cout << "  release" << std::endl;
    env->ReleaseIntArrayElements(addr, a, 0);
    env->ReleaseIntArrayElements(value, v, 0);
    std::cout << "end" << std::endl;
    return;
}

JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_clear(JNIEnv *env, jobject obj){
    AxonerveWordcount *wordcount = instance(env, obj);
    wordcount->clear();
    return;
}
