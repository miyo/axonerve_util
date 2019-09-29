package controllers

import java.io.File
import java.io.{ByteArrayOutputStream, PrintStream}
import java.nio.charset.{Charset, StandardCharsets}

import javax.inject._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import services._

import scala.io._

class WordCountController @Inject()(mcc: MessagesControllerComponents)
    extends MessagesAbstractController(mcc){

  def index() = Action { implicit request : MessagesRequest[AnyContent] =>
    Ok(views.html.wordcountIndex())
  }

  def upload = Action(parse.multipartFormData) { implicit request =>
    request.body.file("file").map { uploadedFile =>
      val filename = uploadedFile.filename
      val contentType = uploadedFile.contentType
      //uploadedFile.ref.moveTo(new File(s"/tmp/$filename"))
      val source = Source.fromFile(uploadedFile.ref)
      var str = ""
      source.getLines().foreach{ s =>
        str += s
      }
      val obj = new WordCountLogic();
      obj.setText(str)
      obj.split();
      val start = System.currentTimeMillis()
      obj.count();
      val end = System.currentTimeMillis()
      obj.sort();
      val result = obj.getResult();
      val hw_start = System.currentTimeMillis()
      obj.doWithFPGA();
      val hw_end = System.currentTimeMillis()

      //Ok("File uploaded, " + s"$filename" + ", " + s"$contentType" + "<br>" + content)
      Ok(views.html.wordcountResult(filename, result, (end-start), (hw_end-hw_start)))
    }.getOrElse {
      Redirect(routes.WordCountController.index).flashing(
        "error" -> "Missing file")
    }
  }

}
