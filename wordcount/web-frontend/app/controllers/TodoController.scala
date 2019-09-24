package controllers

import javax.inject._
import play.api.mvc._

import play.api.data._
import play.api.data.Forms._

import services._

class TodoController @Inject()(mcc: MessagesControllerComponents)
    extends MessagesAbstractController(mcc){

  def hello() = Action { implicit request : MessagesRequest[AnyContent] =>
    Ok("My Hello World")
  }

  def list() = Action { implicit request : MessagesRequest[AnyContent] =>
    val items: Seq[Todo] = Seq(Todo("Todo1"), Todo("Todo2"))
    val message : String = "ここにリストを表示"
    Ok(views.html.list(message, items))
  }

}
