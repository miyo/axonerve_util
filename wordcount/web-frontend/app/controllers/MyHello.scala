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

}
