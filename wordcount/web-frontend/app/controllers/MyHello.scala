package controllers

import javax.inject._
import play.api.mvc._

import play.api.data._
import play.api.data.Forms._

class MyHello @Inject()(mcc: MessagesControllerComponents)
    extends MessagesAbstractController(mcc){

  def hello() = Action { implicit request : MessagesRequest[AnyContent] =>
    Ok(views.html.myhello("My Hello World", "miyo"))
  }

  def jni_test() = Action {implicit request : MessagesRequest[AnyContent] =>
    val obj = new TestWithNativeLibrary("jni-test")
    val a = Array(0, 1, 2, 3, 4, 5)
    val b = Array(0, 1, 2, 3, 4, 5)
    var c = new Array[Int](6)
    obj.add_vec(a, b, c)
    var s = ""
    s += "a ="
    for(i <- 0 until 6){
      s += " " + a(i)
    }
    s += ", b ="
    for(i <- 0 until 6){
      s += " " + b(i)
    }
    s += ", c ="
    for(i <- 0 until 6){
      s += " " + c(i)
    }
    Ok("jni-test: " + s)
  }

  

}
