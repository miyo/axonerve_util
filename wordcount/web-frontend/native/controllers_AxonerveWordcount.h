/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class controllers_AxonerveWordcount */

#ifndef _Included_controllers_AxonerveWordcount
#define _Included_controllers_AxonerveWordcount
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     controllers_AxonerveWordcount
 * Method:    init
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_init
  (JNIEnv *, jobject, jstring);

/*
 * Class:     controllers_AxonerveWordcount
 * Method:    close
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_close
  (JNIEnv *, jobject);

/*
 * Class:     controllers_AxonerveWordcount
 * Method:    reset
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_reset
  (JNIEnv *, jobject);

/*
 * Class:     controllers_AxonerveWordcount
 * Method:    doWordCount
 * Signature: ([B)V
 */
JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_doWordCount
  (JNIEnv *, jobject, jbyteArray);

/*
 * Class:     controllers_AxonerveWordcount
 * Method:    getResult
 * Signature: ([I[I)V
 */
JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_getResult
  (JNIEnv *, jobject, jintArray, jintArray);

/*
 * Class:     controllers_AxonerveWordcount
 * Method:    clear
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_controllers_AxonerveWordcount_clear
  (JNIEnv *, jobject);

#ifdef __cplusplus
}
#endif
#endif
