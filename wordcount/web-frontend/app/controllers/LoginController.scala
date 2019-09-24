package controllers

import javax.inject._
import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import models._
import play.api.data.validation.Valid
import play.api.data.validation.Constraint
import play.api.data.validation.Invalid
import play.api.i18n.I18nSupport

import services._

@Singleton
class LoginController @Inject()(cc: ControllerComponents) extends AbstractController(cc) with I18nSupport {

  val loginUserForm = Form(
    mapping(
      "id" -> text.verifying("id missing" , {!_.isEmpty()}) ,
      "password" -> text.verifying("password missing" , {!_.isEmpty()})
    )
      (UserData.apply)(UserData.unapply)
                           )

  def loginInit() = Action { implicit request =>
     Ok( views.html.login(loginUserForm) )
  }

  def loginSubmit() = Action { implicit request: Request[AnyContent] =>
     loginUserForm.bindFromRequest.fold(
         errors => {           
           BadRequest( views.html.login(errors) )
         },
         success => {
           val loginUser = loginUserForm.bindFromRequest.get
           Ok( views.html.loginSuccess() )
         }        
     )
  }

}
