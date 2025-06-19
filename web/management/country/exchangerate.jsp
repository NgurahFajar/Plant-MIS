<% 

/* 

 * Page Name  		:  exchangerate.jsp

 * Created on 		:  [date] [time] AM/PM 

 * 

 * @author  		:  [authorName] 

 * @version  		:  [version] 

 */



/*******************************************************************

 * Page Description 	: [project description ... ] 

 * Imput Parameters 	: [input parameter ...] 

 * Output 			: [output ...] 

 *******************************************************************/

%>

<%@ page language = "java" %>

<!-- package java -->

<%@ page import = "java.util.*" %>

<!-- package dimata -->

<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->

<%@ page import = "com.dimata.gui.jsp.*" %>

<%@ page import = "com.dimata.qdep.form.*" %>

<!--package hanoman -->

<%@ page import = "com.dimata.hanoman.entity.masterdata.*" %>

<%@ page import = "com.dimata.harisma.entity.masterdata.*" %>

<%@ page import = "com.dimata.hanoman.form.masterdata.*" %>

<%@ page import = "com.dimata.harisma.form.masterdata.*" %>

<%@ page import = "com.dimata.harisma.entity.employee.*" %>

<%@ page import = "com.dimata.hanoman.entity.admin.*" %>



<%@ include file = "../../main/javainit.jsp" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DATA_MANAGEMENT, AppObjInfo.G2_DATA_MANAG_MASTER_D, AppObjInfo.OBJ_D_MANAG_MASTER_EXCHANGE_RATE); %>

<%@ include file = "../../main/checkuser.jsp" %>

<%

/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/

boolean privAdd=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));

boolean privView=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_VIEW));

boolean privUpdate=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));

boolean privDelete=userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));

%>

<!-- Jsp Block -->

<%!



	public String drawList(int iCommand,FrmExchangeRate frmObject, ExchangeRate objEntity, 

		Vector objectClass,  long exchangeRateId, Vector countryVct, Vector employeeVct, int iErrCode, String userLoginName)



	{

		ControlList ctrlist = new ControlList();

		ctrlist.setAreaWidth("100%");

		ctrlist.setListStyle("listgen");

		ctrlist.setTitleStyle("tableheader");

		ctrlist.setCellStyle("cellStyle");

		ctrlist.setHeaderStyle("tableheader");

		ctrlist.addHeader("Exchange Date","20%");

		ctrlist.addHeader("Country","25%");

		ctrlist.addHeader("Selling Rate","10%");

		ctrlist.addHeader("Buying Rate","10%");

		ctrlist.addHeader("Approver","20%");		

		ctrlist.addHeader("Approve","5%");

		ctrlist.addHeader("Status","10%");

		//ctrlist.addHeader("Default","5%");



		ctrlist.setLinkRow(0);

		ctrlist.setLinkSufix("");

		Vector lstData = ctrlist.getData();

		Vector lstLinkData = ctrlist.getLinkData();

		Vector rowx = new Vector(1,1);

		ctrlist.reset();

		int index = -1;

		String whereCls = "";

		String orderCls = "";



		/* selected CountryId*/

		Vector countryid_value = new Vector(1,1);

		Vector countryid_key = new Vector(1,1);

		if(countryVct!=null && countryVct.size()>0){

			for(int k=0; k<countryVct.size(); k++){

				Country country  = (Country)countryVct.get(k);

				countryid_value.add(""+country.getOID());

				countryid_key.add(country.getCountryName()+", "+country.getCurrency());

			}

		}

		



		/* selected EmployeeId*/

		Vector employeeid_value = new Vector(1,1);

		Vector employeeid_key = new Vector(1,1);

		if(employeeVct!=null && employeeVct.size()>0){

			for(int k=0; k<employeeVct.size(); k++){

				Employee employee  = (Employee)employeeVct.get(k);

				employeeid_value.add(""+employee.getOID());

				employeeid_key.add(employee.getFullName());

			}

		}

		

		

		//employeeid_value.add("");

		//employeeid_key.add("---select---");



		/* selected Status*/

		Vector status_value = new Vector(1,1);

		Vector status_key = new Vector(1,1);

		for(int k=0; k<PstExchangeRate.statusStr.length; k++){

			status_value.add(""+k);

			status_key.add(PstExchangeRate.statusStr[k]);

		}

		

		

		String checked = "";



		for (int i = 0; i < objectClass.size(); i++) {

			 ExchangeRate exchangeRate = (ExchangeRate)objectClass.get(i);

			 rowx = new Vector();

			 if(exchangeRateId == exchangeRate.getOID())

				 index = i; 



			 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK || (iCommand == Command.SAVE && frmObject.errorSize() > 0 && exchangeRateId != 0))){

				if(iCommand == Command.SAVE){

					exchangeRate = objEntity;

				}	

				rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_REG_DATE] , exchangeRate.getRegDate(), 1,-5, "formElemen", ""));

				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_COUNTRY_ID],null, ""+exchangeRate.getCountryId(), countryid_value , countryid_key, "", "formElemen"));				

				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_SELLING_RATE] +"\" value=\""+exchangeRate.getSellingRate()+"\" size=\"10\" class=\"formElemen\" style =\"text-align:right\">");

				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_BUYING_RATE] +"\" value=\""+exchangeRate.getBuyingRate()+"\" size=\"10\" class=\"formElemen\" style =\"text-align:right\">");

				

				//rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_EMPLOYEE_ID],null, ""+exchangeRate.getEmployeeId(), employeeid_value , employeeid_key, "", "formElemen"));

				

				rowx.add(exchangeRate.getOperator());

				

				

				if(exchangeRate.getApprove()){

					checked = "checked";

				}

				else{

					checked = "";

				}

				

				rowx.add("<input type=\"checkbox\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_APPROVE] +"\" value=\"1\" "+checked+">");

				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_STATUS],null, ""+exchangeRate.getStatus(), status_value , status_key, "", "formElemen"));

				

				if(exchangeRate.getUsedAsDefault()){

					checked = "checked";

				}

				else{

					checked = "";

				}

				

				//rowx.add("<input type=\"checkbox\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_USED_AS_DEFAULT] +"\" value=\"1\" "+checked+">");

			}else{



				String str_dt_RegDate = ""; 

				try{

					Date dt_RegDate = exchangeRate.getRegDate();

					if(dt_RegDate==null){

						dt_RegDate = com.dimata.util.DateCalc.getDate();

					}



				str_dt_RegDate = Formater.formatDate(dt_RegDate, "dd MMMM yyyy");

				}catch(Exception e){ str_dt_RegDate = ""; }
                                try{
                                    try{ rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(exchangeRate.getOID())+"')\">"+str_dt_RegDate+"</a>");
                                    } catch(Exception exc23){
                                    System.out.println(">>>  "+exc23);
                                    }

                                    try{
                                    rowx.add(getCountryName(exchangeRate.getCountryId(), countryVct));
                                    } catch(Exception exc23){
                                    System.out.println(">>>  "+exc23);
                                    }

                                    try{
                                    rowx.add("<div align=\"right\">"+Formater.formatNumber(exchangeRate.getSellingRate(),"##,###.##")+"</div>");
                                    } catch(Exception exc23){
                                    System.out.println(">>>  "+exc23);
                                    }

                                    try{
                                        rowx.add("<div align=\"right\">"+Formater.formatNumber(exchangeRate.getBuyingRate(),"##,###.##")+"</div>");
                                    } catch(Exception exc23){
                                    System.out.println(">>>  "+exc23);
                                    }

                                    //rowx.add(getEmployeeName(exchangeRate.getEmployeeId(), employeeVct));
                                    try{
                                    rowx.add(exchangeRate.getOperator());
                                    } catch(Exception exc23){
                                    System.out.println(">>>  "+exc23);
                                    }

                                    if(exchangeRate.getApprove()){

                                    rowx.add("Yes");

				}else{

					rowx.add("No");

				}
                                String stExc1 = "Status not found";
                                try{
                                    stExc1= PstExchangeRate.statusStr[exchangeRate.getStatus()];
                                } catch(Exception exc23){
                                    System.out.println(">>> stExc1= PstExchangeRate.statusStr[exchangeRate.getStatus()]; "+exc23);
                                }
                                  rowx.add(stExc1);
                                } catch(Exception exc){
                                  System.out.println(">> rowx.add(PstExchangeRate.statusStr[exchangeRate.getStatus()]);"+exc);
                                }
				//if(exchangeRate.getUsedAsDefault()){

				//rowx.add("Yes");

				//}else{

				//	rowx.add("No");

				//}

			} 



			lstData.add(rowx);

		}



		 rowx = new Vector();



		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0 && exchangeRateId == 0)){ 

				rowx.add(ControlDate.drawDateWithStyle(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_REG_DATE] , (objEntity.getRegDate()==null) ? com.dimata.util.DateCalc.getDate() : objEntity.getRegDate(), 1,-5, "formElemen", ""));

				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_COUNTRY_ID],null, ""+objEntity.getCountryId(), countryid_value , countryid_key, "", "formElemen"));				

				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_SELLING_RATE] +"\" value=\""+objEntity.getSellingRate()+"\" size=\"10\" class=\"formElemen\">");

				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_BUYING_RATE] +"\" value=\""+objEntity.getBuyingRate()+"\" size=\"10\" class=\"formElemen\">");

				

				//rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_EMPLOYEE_ID],null, ""+objEntity.getEmployeeId(), employeeid_value , employeeid_key, "", "formElemen"));

				

				rowx.add(userLoginName);

				

				if(objEntity.getApprove()){

					checked = "checked";

				}

				else{

					checked = "";

				}

				

				rowx.add("<input type=\"checkbox\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_APPROVE] +"\" value=\"1\"  "+checked+">");

				rowx.add(ControlCombo.draw(frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_STATUS],null, ""+objEntity.getStatus(), status_value , status_key, "", "formElemen"));

				

				if(objEntity.getUsedAsDefault()){

					checked = "checked";

				}

				else{

					checked = "";

				}

				

				//rowx.add("<input type=\"checkbox\" name=\""+frmObject.fieldNames[FrmExchangeRate.FRM_FIELD_USED_AS_DEFAULT] +"\" value=\"1\" "+checked+">");



		}



		lstData.add(rowx);



		return ctrlist.draw();

	}

	

	

	public String drawHistory(Vector objectClass,  Vector countryVct, Vector employeeVct)

	{

		ControlList ctrlist = new ControlList();

		ctrlist.setAreaWidth("100%");

		ctrlist.setListStyle("listgen");

		ctrlist.setTitleStyle("tableheader");

		ctrlist.setCellStyle("cellStyle");

		ctrlist.setHeaderStyle("tableheader");

		ctrlist.addHeader("Exchange Date","15%");

		ctrlist.addHeader("Country","25%");

		ctrlist.addHeader("Selling Rate","10%");

		ctrlist.addHeader("Buying Rate","10%");

		ctrlist.addHeader("Approver","20%");		

		//ctrlist.addHeader("Approve","5%");

		ctrlist.addHeader("Update Date","15%");

		ctrlist.addHeader("Update By","5%");

		ctrlist.addHeader("Status","10%");

		//ctrlist.addHeader("Default","5%");



		ctrlist.setLinkRow(0);

		ctrlist.setLinkSufix("");

		Vector lstData = ctrlist.getData();

		Vector lstLinkData = ctrlist.getLinkData();

		Vector rowx = new Vector(1,1);

		ctrlist.reset();

		int index = -1;

		String whereCls = "";

		String orderCls = "";



		

		String checked = "";



		for (int i = 0; i < objectClass.size(); i++) {

			 ExchangeRate exchangeRate = (ExchangeRate)objectClass.get(i);

			 rowx = new Vector();

			 

				String str_dt_RegDate = ""; 

				try{

					Date dt_RegDate = exchangeRate.getRegDate();

					if(dt_RegDate==null){

						dt_RegDate = com.dimata.util.DateCalc.getDate();

					}



				str_dt_RegDate = Formater.formatDate(dt_RegDate, "dd MMMM yyyy hh:mm:ss");

				}catch(Exception e){ str_dt_RegDate = ""; }

				

				rowx.add(str_dt_RegDate);				

				rowx.add(getCountryName(exchangeRate.getCountryId(), countryVct));	

				rowx.add("<div align=\"right\">"+Formater.formatNumber(exchangeRate.getSellingRate(),"##,###.##"));

				rowx.add("<div align=\"right\">"+Formater.formatNumber(exchangeRate.getBuyingRate(),"##,###.##"));

				//rowx.add(getEmployeeName(exchangeRate.getEmployeeId(), employeeVct));

				rowx.add(exchangeRate.getOperator());

				

				String str_dt_RegDate_His = ""; 

				try{

					Date dt_RegDatex = exchangeRate.getHistoryDate();

					if(dt_RegDatex==null){

						dt_RegDatex = com.dimata.util.DateCalc.getDate();

					}



				str_dt_RegDate_His = Formater.formatDate(dt_RegDatex, "dd MMMM yyyy hh:mm:ss");

				}catch(Exception e){ str_dt_RegDate_His = ""; }

				

				rowx.add(str_dt_RegDate_His);

				rowx.add(exchangeRate.getHistoryOperator());

				

				/*if(exchangeRate.getApprove()){

				rowx.add("Yes");

				}else{

					rowx.add("No");

				}*/

				String statusStr= "Status not found";
                                try{ statusStr=PstExchangeRate.statusStr[exchangeRate.getStatus()]; }
                                catch(Exception exc1){  System.out.println(exc1);}
				rowx.add(statusStr);


				//if(exchangeRate.getUsedAsDefault()){

				//rowx.add("Yes");

				//}else{

				//	rowx.add("No");

				//}

			



			lstData.add(rowx);

		

		}



		return ctrlist.draw();

	}

	

	

	public String getCountryName(long oid, Vector country){

		if(country!=null && country.size()>0){

			for(int i=0; i<country.size(); i++){

				Country coun = (Country)country.get(i);

				if(coun.getOID()==oid){

					return coun.getCountryName()+" "+coun.getCurrency();					

				}

			}

		}

		return "";

	}



	public String getEmployeeName(long oid, Vector employee){

		if(employee!=null && employee.size()>0){

			for(int i=0; i<employee.size(); i++){

				Employee emp = (Employee)employee.get(i);

				if(emp.getOID()==oid){

					return emp.getFullName();					

				}

			}

		}

		return "";

	}



%>

<%

int iCommand = FRMQueryString.requestCommand(request);

int start = FRMQueryString.requestInt(request, "start");

int prevCommand = FRMQueryString.requestInt(request, "prev_command");

long oidExchangeRate = FRMQueryString.requestLong(request, "hidden_exchange_rate_id");



/*variable declaration*/

int recordToGet = 10;

String msgString = "";

int iErrCode = FRMMessage.NONE;

String whereClause = PstExchangeRate.fieldNames[PstExchangeRate.FLD_STATUS]+"="+PstExchangeRate.STATUS_CURRENT_USED;

String orderClause = "";



String orderClauseCtr = PstCountry.fieldNames[PstCountry.FLD_COUNTRY_NAME];

Vector countryVct = PstCountry.list(0,0, "", orderClauseCtr);

Vector employeeVct = PstEmployee.listAll(); 



CtrlExchangeRate ctrlExchangeRate = new CtrlExchangeRate(request);

ControlLine ctrLine = new ControlLine();

Vector listExchangeRate = new Vector(1,1);



/*switch statement */

iErrCode = ctrlExchangeRate.action(iCommand , oidExchangeRate);

/* end switch*/

FrmExchangeRate frmExchangeRate = ctrlExchangeRate.getForm();



/*count list All ExchangeRate*/

int vectSize = PstExchangeRate.getCount(whereClause);



/*switch list ExchangeRate*/

if((iCommand == Command.FIRST || iCommand == Command.PREV )||

  (iCommand == Command.NEXT || iCommand == Command.LAST)){

		start = ctrlExchangeRate.actionList(iCommand, start, vectSize, recordToGet);

 } 

/* end switch list*/



ExchangeRate exchangeRate = ctrlExchangeRate.getExchangeRate();

msgString =  ctrlExchangeRate.getMessage();



/* get record to display */

listExchangeRate = PstExchangeRate.list(start,recordToGet, whereClause , orderClause);



/*handle condition if size of record to display = 0 and start > 0 	after delete*/

if (listExchangeRate.size() < 1 && start > 0)

{

	 if (vectSize - recordToGet > recordToGet)

			start = start - recordToGet;   //go to Command.PREV

	 else{

		 start = 0 ;

		 iCommand = Command.FIRST;

		 prevCommand = Command.FIRST; //go to Command.FIRST

	 }

	 listExchangeRate = PstExchangeRate.list(start,recordToGet, whereClause , orderClause);

}







//---------- proceed history



whereClause = PstExchangeRate.fieldNames[PstExchangeRate.FLD_COUNTRY_ID]+"="+exchangeRate.getCountryId()+" AND "+

	PstExchangeRate.fieldNames[PstExchangeRate.FLD_STATUS]+"="+PstExchangeRate.STATUS_HISTORY+

	" OR "+PstExchangeRate.fieldNames[PstExchangeRate.FLD_STATUS]+"="+PstExchangeRate.STATUS_UPDATE;



orderClause = PstExchangeRate.fieldNames[PstExchangeRate.FLD_HISTORY_DATE]+" DESC";



Vector listHistory = PstExchangeRate.list(0,0, whereClause, orderClause);







%>

<html><!-- #BeginTemplate "/Templates/main_s_2.dwt" -->

<head>

<!-- #BeginEditable "doctitle" --> 

<title>Hanoman - Daily Rate</title>

<script language="JavaScript">



<%if(!privView &&  !privAdd && !privUpdate && !privDelete){%>

	window.location="<%=approot%>/nopriv.jsp";

<%}%>



function cmdAdd(){

	document.frmexchangerate.hidden_exchange_rate_id.value="0";

	document.frmexchangerate.command.value="<%=Command.ADD%>";

	document.frmexchangerate.prev_command.value="<%=prevCommand%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdAsk(oidExchangeRate){

	document.frmexchangerate.hidden_exchange_rate_id.value=oidExchangeRate;

	document.frmexchangerate.command.value="<%=Command.ASK%>";

	document.frmexchangerate.prev_command.value="<%=prevCommand%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdConfirmDelete(oidExchangeRate){

	document.frmexchangerate.hidden_exchange_rate_id.value=oidExchangeRate;

	document.frmexchangerate.command.value="<%=Command.DELETE%>";

	document.frmexchangerate.prev_command.value="<%=prevCommand%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdSave(){

	document.frmexchangerate.command.value="<%=Command.SAVE%>";

	document.frmexchangerate.prev_command.value="<%=prevCommand%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdEdit(oidExchangeRate){

	document.frmexchangerate.hidden_exchange_rate_id.value=oidExchangeRate;

	document.frmexchangerate.command.value="<%=Command.EDIT%>";

	document.frmexchangerate.prev_command.value="<%=prevCommand%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdCancel(oidExchangeRate){

	document.frmexchangerate.hidden_exchange_rate_id.value=oidExchangeRate;

	document.frmexchangerate.command.value="<%=Command.EDIT%>";

	document.frmexchangerate.prev_command.value="<%=prevCommand%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdBack(){

	document.frmexchangerate.command.value="<%=Command.BACK%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdListFirst(){

	document.frmexchangerate.command.value="<%=Command.FIRST%>";

	document.frmexchangerate.prev_command.value="<%=Command.FIRST%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdListPrev(){

	document.frmexchangerate.command.value="<%=Command.PREV%>";

	document.frmexchangerate.prev_command.value="<%=Command.PREV%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdListNext(){

	document.frmexchangerate.command.value="<%=Command.NEXT%>";

	document.frmexchangerate.prev_command.value="<%=Command.NEXT%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function cmdListLast(){

	document.frmexchangerate.command.value="<%=Command.LAST%>";

	document.frmexchangerate.prev_command.value="<%=Command.LAST%>";

	document.frmexchangerate.action="exchangerate.jsp";

	document.frmexchangerate.submit();

}



function backMenu(){

	document.frmexchangerate.action="<%=approot%>/management/main_man.jsp";

	document.frmexchangerate.submit();

}



//-------------- script form image -------------------



function cmdDelPict(oidExchangeRate){

	document.frmimage.hidden_exchange_rate_id.value=oidExchangeRate;

	document.frmimage.command.value="<%=Command.POST%>";

	document.frmimage.action="exchangerate.jsp";

	document.frmimage.submit();

}



//-------------- script control line -------------------

	function MM_swapImgRestore() { //v3.0

		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;

	}



function MM_preloadImages() { //v3.0

		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();

		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)

		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}

	}



function MM_findObj(n, d) { //v4.0

		var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {

		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}

		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];

		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);

		if(!x && document.getElementById) x=document.getElementById(n); return x;

	}



function MM_swapImage() { //v3.0

		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)

		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}

	}



</script>

<!-- #EndEditable -->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "inc_hdscr" --> 

<%@ include file="../../main/hdscript.jsp"%>

<!-- #EndEditable -->

<!-- #BeginEditable "clientscript" --> 

<script language="JavaScript">

<!--



//-->

</script>

<!-- #EndEditable -->





<link rel="stylesheet" href="<%=approot%>/css/default.css" type="text/css">



</head>



<body bgcolor="#FFFFFF" text="#000000" onLoad="MM_preloadImages('<%=approot%>/image/reserv_f2.jpg','<%=approot%>/image/cashiering_f2.jpg','<%=approot%>/image/datamng_f2.jpg','<%=approot%>/image/ledger_f2.jpg','<%=approot%>/image/logout_f2.jpg','<%=approot%>/images/ctr_line/add_f2.jpg','<%=approot%>/images/ctr_line/back_f2.jpg')" leftmargin="3" topmargin="3">

<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">

  

  <tr> 

    <td colspan="2" valign="top">

	<!-- #BeginEditable "inc_hdr" --> 

      <%@ include file="../../main/header.jsp"%>

      <!-- #EndEditable --> 

	</td> 

  </tr>

  <tr> 

    <td width="100%" align="center" valign="top">

	<table width="98%" border="0" cellpadding="1" cellspacing="0">

        

        <tr> 

          <td align="center" valign="top" class="frmcontents"><table width="100%" border="0" cellpadding="0" cellspacing="0">

              

              <tr> 

                <td  height="178" align="center" valign="middle" class="contents">

				<table width="100%" border="0" cellspacing="2" cellpadding="2">

				  <tr>

					<td>

					<!-- #BeginEditable "contents" --> 

            <form name="frmexchangerate" method ="post" action="">

              <input type="hidden" name="command" value="<%=iCommand%>">

              <input type="hidden" name="vectSize" value="<%=vectSize%>">

              <input type="hidden" name="start" value="<%=start%>">

              <input type="hidden" name="prev_command" value="<%=prevCommand%>">

              <input type="hidden" name="hidden_exchange_rate_id" value="<%=oidExchangeRate%>">

			  <input type="hidden" name="<%=FrmExchangeRate.fieldNames[FrmExchangeRate.FRM_FIELD_OPERATOR]%>" value="<%=userLoginName%>"> 

			  

			  <table width="100%" border="0" cellspacing="2" cellpadding="2">

  <tr>

                              <td width="1%">&nbsp;</td>

                              <td width="98%"> 

                                <table width="100%" border="0" cellspacing="0" cellpadding="0">

                      <tr align="left" valign="top"> 

                        <td height="8"  colspan="3"> 

                          <table width="100%" border="0" cellspacing="1" cellpadding="1">

                            <tr align="left" valign="top"> 

                                          <td height="8" valign="middle" colspan="3" class="title">DAILY 

                                            RATE</td>

                            </tr>

                            <%

							try{

							%>

                            <tr align="left" valign="top"> 

                              <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand, frmExchangeRate, exchangeRate, listExchangeRate,oidExchangeRate, countryVct, employeeVct, iErrCode, userLoginName)%> </td>

                            </tr>

                            <% 

						  }catch(Exception exc){ 
                                                    System.out.println(" EXC "+exc);
						  }%>

                            <tr align="left" valign="top"> 

                              <td height="8" align="left" colspan="3" class="command"> 

                                <span class="command"> 

                                <% 

								   int cmd = 0;

									   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 

										(iCommand == Command.NEXT || iCommand == Command.LAST))

											cmd =iCommand; 

								   else{

									  if(iCommand == Command.NONE || prevCommand == Command.NONE)

										cmd = Command.FIRST;

									  else 

									  	cmd =prevCommand; 

								   } 

							    %>

                                <% ctrLine.setLocationImg(approot+"/images/ctr_line");

							   	ctrLine.initDefault();

								 %>

                                <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>

                            </tr>

                          </table>

                          <%if(iCommand!=Command.ADD && iCommand!=Command.EDIT && iCommand!=Command.ASK && iErrCode==FRMMessage.NONE){%>

                                      <table width="52%" border="0" cellspacing="2" cellpadding="3">

                                        <tr> 

                              <% if(privAdd){%>

                                          <td width="7%"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100','','<%=approot%>/images/ctr_line/add_f2.jpg',1)"><img name="Image100" border="0" src="<%=approot%>/images/ctr_line/add.jpg" width="24" height="24" alt="Add New Exchange Rate"></a></td>

                                          <td nowrap width="16%"><a href="javascript:cmdAdd()" class="command">Add 

                                            New </a></td>

                              <%}%>

                                          <td width="6%"><a href="javascript:backMenu()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image300','','<%=approot%>/images/ctr_line/back_f2.jpg',1)"><img name="Image300" border="0" src="<%=approot%>/images/ctr_line/back.jpg" width="24" height="24" alt="Back To Master Data Management Menu"></a></td>

                                          <td nowrap width="71%"><a href="javascript:backMenu()" class="command">Back 

                                            To Menu</a></td>

                            </tr>

                          </table>

                          <%}%>

                        </td>

                      </tr>

                      <tr align="left" valign="top" > 

                        <td colspan="3" class="command"> 

                          <%

									ctrLine.setLocationImg(approot+"/images/ctr_line");

									ctrLine.initDefault();

									ctrLine.setTableWidth("80%");

									String scomDel = "javascript:cmdAsk('"+oidExchangeRate+"')";

									String sconDelCom = "javascript:cmdConfirmDelete('"+oidExchangeRate+"')";

									String scancel = "javascript:cmdEdit('"+oidExchangeRate+"')";

									ctrLine.setBackCaption("Back to List");

									ctrLine.setCommandStyle("buttonlink");

									ctrLine.setDeleteCaption("");

									ctrLine.setSaveCaption("Save Data");

									ctrLine.setAddCaption("");



									if (privDelete){

										ctrLine.setConfirmDelCommand(sconDelCom);

										ctrLine.setDeleteCommand(scomDel);

										ctrLine.setEditCommand(scancel);

									}else{ 

										ctrLine.setConfirmDelCaption("");

										ctrLine.setDeleteCaption("");

										ctrLine.setEditCaption("");

									}



									if(privAdd == false  && privUpdate == false){

										ctrLine.setSaveCaption("");

									}



									if (privAdd == false){

										ctrLine.setAddCaption("");

									}

									%>

                          <%if(iCommand==Command.ADD || iCommand==Command.EDIT || iCommand==Command.ASK || iErrCode !=FRMMessage.NONE){%>

                          <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> 

                          <%}%>

                        </td>

                      </tr>

					  <tr align="left" valign="top" > 

                        <td colspan="3" class="command">&nbsp;</td>

                      </tr>

                      <%if(iCommand==Command.EDIT){%>

					  <tr align="left" valign="top" > 

                        <td colspan="3" class="command">&nbsp;<b>HISTORY LIST</b></td>

                      </tr>

                      <tr align="left" valign="top" > 

                        <td colspan="3" class="command">

						

						<%=drawHistory(listHistory,  countryVct, employeeVct)%>

						</td>

                      </tr>

					  <%}%>

                      <tr align="left" valign="top" >

                        <td colspan="3" class="command">&nbsp;</td>

                      </tr>

                    </table>

                  </td>

                              <td width="1%">&nbsp;</td>

  </tr>

</table>

              

            </form>

            <!-- #EndEditable --> </td>

				  </tr>

				</table>

                  

                </td>

              </tr>

            </table></td>

        </tr>

      </table></td>

    <td width="1">&nbsp;</td>

  </tr>

  <tr>

    <td height="15"  align="center" valign="top" collspan="2">

	<!-- #BeginEditable "inc_ft" --> 

      <%@ include file="../../main/footer.jsp"%>

      <!-- #EndEditable --></td>

  </tr>

</table>

</body>

<!-- #EndTemplate --></html>

