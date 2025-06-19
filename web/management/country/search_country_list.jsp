<% 

/* 

 * Page Name  		:  country.jsp

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

<%@ page import = "java.util.*,

                   com.dimata.hanoman.entity.search.SrcCountry,

                   com.dimata.hanoman.form.search.FrmSrcCountry" %>

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

<%@ page import = "com.dimata.hanoman.entity.admin.*" %>



<%@ include file = "../../main/javainit.jsp" %>

<% int  appObjCode = AppObjInfo.composeObjCode(AppObjInfo.G1_DATA_MANAGEMENT, AppObjInfo.G2_DATA_MANAG_MASTER_D, AppObjInfo.OBJ_D_MANAG_MASTER_COUNTRY); %>

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



	public String drawList(Vector objectClass ,  long countryId)



	{

		ControlList ctrlist = new ControlList();

		ctrlist.setAreaWidth("100%");

		ctrlist.setListStyle("listgen");

		ctrlist.setTitleStyle("tableheader");

		ctrlist.setCellStyle("cellStyle");

		ctrlist.setHeaderStyle("tableheader");

		ctrlist.addHeader("Code","6%");

		ctrlist.addHeader("Country Name","22%");

		ctrlist.addHeader("Nationality","22%");

		ctrlist.addHeader("Currency","16%");

		ctrlist.addHeader("Capital City","16%");

		ctrlist.addHeader("Time To Gmt","7%");

		ctrlist.addHeader("Time To Locale","7%");



		ctrlist.setLinkRow(0);

		ctrlist.setLinkSufix("");

		Vector lstData = ctrlist.getData();

		Vector lstLinkData = ctrlist.getLinkData();

		ctrlist.setLinkPrefix("javascript:cmdEdit('");

		ctrlist.setLinkSufix("')");

		ctrlist.reset();

		int index = -1;



		for (int i = 0; i < objectClass.size(); i++) {

			Country country = (Country)objectClass.get(i);

			 Vector rowx = new Vector();

			 if(countryId == country.getOID())

				 index = i;



			rowx.add(country.getIdCode());



			rowx.add(country.getCountryName());



			rowx.add(country.getNationality());

			

			rowx.add(country.getCurrency());



			rowx.add(country.getCapitalCity());



			rowx.add(String.valueOf(country.getTimeToGmt()));



			rowx.add(String.valueOf(country.getTimeToGmt()-8));



			lstData.add(rowx);

			lstLinkData.add(String.valueOf(country.getOID()));

		}



		return ctrlist.draw();

	}



%>

<%

int iCommand = FRMQueryString.requestCommand(request);

int start = FRMQueryString.requestInt(request, "start");

int prevCommand = FRMQueryString.requestInt(request, "prev_command");

long oidCountry = FRMQueryString.requestLong(request, "hidden_country_id");

String name = FRMQueryString.requestString(request, "name");

String nationality = FRMQueryString.requestString(request, "nationality");



if(iCommand==Command.NONE){

	iCommand = Command.SUBMIT;

}



/*variable declaration*/

int recordToGet = 12;

String msgString = "";

int iErrCode = FRMMessage.NONE;

String whereClause = "";

String orderClause = PstCountry.fieldNames[PstCountry.FLD_COUNTRY_NAME];



CtrlCountry ctrlCountry = new CtrlCountry(request);

ControlLine ctrLine = new ControlLine();

Vector listCountry = new Vector(1,1);



/*switch statement */

iErrCode = ctrlCountry.action(iCommand , oidCountry);

FrmCountry frmCountry = ctrlCountry.getForm();



/* end switch*/

/*count list All Country*/

Vector listAllCountry = PstCountry.listAll();

//int vectSize = listAllCountry.size();

int vectSize = PstCountry.getCountCountry(whereClause,name,nationality);

/*switch list Country*/

    if(iCommand != Command.BACK){

        start = ctrlCountry.actionList(iCommand, start, vectSize, recordToGet);

     }



/* end switch list*/



Country country = ctrlCountry.getCountry();

msgString =  ctrlCountry.getMessage();

if(iCommand==Command.SAVE && msgString.length()==0){

	msgString = "data have been saved";

}



oidCountry = country.getOID();



/* get record to display */

if(iCommand==Command.EDIT || iCommand==Command.ADD || iCommand==Command.SUBMIT ||

   iCommand==Command.ASK || iCommand==Command.SAVE ||

   iCommand == Command.FIRST || iCommand == Command.PREV ||

   iCommand == Command.NEXT || iCommand == Command.LAST || iCommand == Command.BACK){

    listCountry = PstCountry.listCountry(start,recordToGet, whereClause , orderClause, name, nationality);

}

/*handle condition if size of record to display = 0 and start > 0 	after delete*/

if (listCountry.size() < 1 && start > 0)

{

	 if (vectSize - recordToGet > recordToGet)

			start = start - recordToGet;   //go to Command.PREV

	 else{

		 start = 0 ;

		 iCommand = Command.FIRST;

		 prevCommand = Command.FIRST; //go to Command.FIRST

	 }

	 listCountry = PstCountry.list(start,recordToGet, whereClause , orderClause);

}

%>

<html><!-- #BeginTemplate "/Templates/main_s_3.dwt" -->

<head>

<!-- #BeginEditable "doctitle" --> 

<title>country list</title>

<script language="JavaScript">



<%if(!privView &&  !privAdd && !privUpdate && !privDelete){%>

	window.location="<%=approot%>/nopriv.jsp";

<%}%>



<%if(iCommand==Command.EDIT || iCommand==Command.ADD || iCommand==Command.ASK || (iCommand==Command.SAVE)){%>

window.location="#go";

<%}%>



function cmdAdd(){

	document.frmcountry.command.value="<%=Command.ADD%>";

	document.frmcountry.prev_command.value="<%=prevCommand%>";

	document.frmcountry.hidden_country_id.value="0";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

}



function cmdAsk(oidCountry){

	document.frmcountry.hidden_country_id.value=oidCountry;

	document.frmcountry.command.value="<%=Command.ASK%>";

	document.frmcountry.prev_command.value="<%=prevCommand%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

}



function cmdConfirmDelete(oidCountry){

	document.frmcountry.hidden_country_id.value=oidCountry;

	document.frmcountry.command.value="<%=Command.DELETE%>";

	document.frmcountry.prev_command.value="<%=prevCommand%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

}

function cmdSave(){

	document.frmcountry.command.value="<%=Command.SAVE%>";

	document.frmcountry.prev_command.value="<%=prevCommand%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

	}



function cmdEdit(oidCountry){

	document.frmcountry.hidden_country_id.value=oidCountry;

	document.frmcountry.command.value="<%=Command.EDIT%>";

	document.frmcountry.prev_command.value="<%=prevCommand%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

	}



function cmdCancel(oidCountry){

	document.frmcountry.hidden_country_id.value=oidCountry;

	document.frmcountry.command.value="<%=Command.EDIT%>";

	document.frmcountry.prev_command.value="<%=prevCommand%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

}



function cmdBack(){

	document.frmcountry.command.value="<%=Command.BACK%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

	}



function cmdListFirst(){

	document.frmcountry.command.value="<%=Command.FIRST%>";

	document.frmcountry.prev_command.value="<%=Command.FIRST%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

}



function cmdListPrev(){

	document.frmcountry.command.value="<%=Command.PREV%>";

	document.frmcountry.prev_command.value="<%=Command.PREV%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

	}



function cmdListNext(){

	document.frmcountry.command.value="<%=Command.NEXT%>";

	document.frmcountry.prev_command.value="<%=Command.NEXT%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

}



function cmdListLast(){

	document.frmcountry.command.value="<%=Command.LAST%>";

	document.frmcountry.prev_command.value="<%=Command.LAST%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

}



function backMenu(){

	document.frmcountry.action="<%=approot%>/management/main_man.jsp";

	document.frmcountry.submit();

}



function cmdSearch(){

	document.frmcountry.command.value="<%=Command.SUBMIT%>";

	document.frmcountry.action="search_country_list.jsp";

	document.frmcountry.submit();

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



<body bgcolor="#FFFFFF" text="#000000" onLoad="MM_preloadImages('<%=approot%>/image/reserv_f2.jpg','<%=approot%>/image/cashiering_f2.jpg','<%=approot%>/image/datamng_f2.jpg','<%=approot%>/image/ledger_f2.jpg','<%=approot%>/image/logout_f2.jpg','<%=approot%>/images/ctr_line/search_f2.jpg','<%=approot%>/images/ctr_line/add_f2.jpg','<%=approot%>/images/ctr_line/back_f2.jpg')" leftmargin="3" topmargin="3">

<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">

  <!--DWLayoutTable-->

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

        <!--DWLayoutTable-->

        <tr> 

          <td align="center" valign="top" class="frmcontents"><table width="100%" border="0" cellpadding="0" cellspacing="0">

              <!--DWLayoutTable-->

              <tr> 

                <td  height="178" align="center" valign="middle" class="contents">

				<table width="100%" border="0" cellspacing="2" cellpadding="2">

				  <tr>

					<td>

					<!-- #BeginEditable "contents" -->

              <form name="frmcountry" method ="post" action="">

              <input type="hidden" name="command" value="<%=iCommand%>">

              <input type="hidden" name="vectSize" value="<%=vectSize%>">

              <input type="hidden" name="start" value="<%=start%>">

              <input type="hidden" name="prev_command" value="<%=prevCommand%>">

              <input type="hidden" name="hidden_country_id" value="<%=oidCountry%>">



			  <table width="100%" border="0" cellspacing="0" cellpadding="1" height="100%">

                <tr>

                              <td width="2%">&nbsp;</td>

                              <td width="96%"> 

                                <table width="100%" border="0" cellspacing="1" cellpadding="0">

                                  <tr align="left" valign="top"> 

                                    <td height="21" valign="middle" colspan="4"> 

                                      <div align="left"><b><font color="#000000">SEARCH 

                                        FOR COUNTRY</font></b></div>

                                    </td>

                                  </tr>

                                  <tr align="left" valign="top"> 

                                    <td height="21" valign="top" width="8%"> 

                                      <div align="left">Name&nbsp;</div>

                                    </td>

                                    <td height="21" colspan="3" width="92%"> 

                                      <!--input type="text" name="FRM_FIELD_COMP_NAME"  value="<!--%= srcContact.getCompName() %>" class="formElemen"-->

                                      <%--<input type="text" name="<%=frmsrcContactTravel.fieldNames[FrmSrcContactTravel.FRM_FIELD_COMP_NAME] %>"  value="<%= srcContact.getCompName() %>" class="elemenForm">--%>

                                      <input type="text" name="name" class="formElemen" value="<%=name%>" size="20">

                                  <tr align="left" valign="top"> 

                                    <td height="21" valign="top" width="8%"> 

                                      <div align="left">Nationality&nbsp;</div>

                                    </td>

                                    <td height="21" colspan="3" width="92%"> 

                                      <!--input type="text" name="FRM_FIELD_NAME"  value="<!--%= srcContact.getName() %>" class="formElemen"-->

                                      <%-- <input type="text" name="<%=frmsrcContactTravel.fieldNames[FrmSrcContactTravel.FRM_FIELD_NAME] %>"  value="<%= srcContact.getName() %>" class="elemenForm">--%>

                                      <input type="text" name="nationality" class="formElemen" value="<%=nationality%>" size="20">

                                  <tr align="left" valign="top"> 

                                    <td height="8" valign="middle" width="8%">&nbsp;</td>

                                    <td height="8" colspan="3" width="92%"> 

                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">

                                        <tr> 

                                          <td width="4%"><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1010','','<%=approot%>/images/ctr_line/search_f2.jpg',1)"><img name="Image1010" border="0" src="<%=approot%>/images/ctr_line/search.jpg" width="24" height="24" alt="List Country"></a></td>

                                          <td width="24%"><a href="javascript:cmdSearch()">Search</a></td>

                                          <td width="7%"> 

                                            <% if(privAdd && (listCountry==null || listCountry.size()==0)){%>

                                            <a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','<%=approot%>/images/ctr_line/add_f2.jpg',1)"><img name="Image10" border="0" src="<%=approot%>/images/ctr_line/add.jpg" width="24" height="24" alt="Add New Country"></a> 

                                            <%}%>

                                          </td>

                                          <td width="65%"> 

                                            <% if(privAdd && (listCountry==null || listCountry.size()==0)){%>

                                            <a href="javascript:cmdAdd()">Add 

                                            New </a> 

                                            <%}%>

                                          </td>

                                        </tr>

                                      </table>

                                    </td>

                                  </tr>

                                  <tr align="left" valign="top" > 

                                    <td colspan="4" class="command"> </td>

                                  </tr>

                                </table>



                   <%if(iCommand==Command.BACK || iCommand==Command.ASK || iCommand==Command.SAVE || iCommand==Command.ADD ||iCommand==Command.EDIT || iCommand==Command.SUBMIT || iCommand==Command.FIRST || iCommand==Command.NEXT || iCommand==Command.PREV || iCommand==Command.LAST){%>

                                <table width="100%" border="0">

                                  <tr align="left" valign="top"> 

                                    <td height="14" valign="middle" colspan="3" class="title">&nbsp;COUNTRY 

                                      LIST </td>

                                  </tr>

                                  <%

					  try{

					    if (listCountry.size()>0){

					  %>

                                  <tr align="left" valign="top"> 

                                    <td valign="middle" colspan="3"> <%= drawList(listCountry,oidCountry)%> </td>

                                  </tr>

                                  <tr align="left" valign="top"> 

                                    <td height="8" align="left" colspan="3" class="command"><span class="command"> 

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

                                      </span> <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%></td>

                                  </tr>

                                  <% }

                       else{ %>

                                  <span class="msgquestion"><br>

                                  &nbsp;Records is empty ...</span> 

                                  <%  }



					  }catch(Exception exc){

					  }%>

                                </table>









					 <table width="49%" border="0" cellspacing="2" cellpadding="3">

                     <tr>

					  <% if(privAdd){%>

                                    <td width="7%"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image100','','<%=approot%>/images/ctr_line/add_f2.jpg',1)"><img name="Image100" border="0" src="<%=approot%>/images/ctr_line/add.jpg" width="24" height="24" alt="Add New Country"></a></td>

                                    <td nowrap width="17%"><a href="javascript:cmdAdd()" class="command">Add 

                                      New </a></td>

						<%}%>

                                    <td width="7%"><a href="javascript:backMenu()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image300','','<%=approot%>/images/ctr_line/back_f2.jpg',1)"><img name="Image300" border="0" src="<%=approot%>/images/ctr_line/back.jpg" width="24" height="24" alt="Back To Master Data Management Menu"></a></td>

                                    <td nowrap width="69%"><a href="javascript:backMenu()" class="command">Back 

                                      To Menu</a></td>

                      </tr>

                    </table>

                    <%}%>

                  </td>

                              <td width="2%">&nbsp;</td>

                </tr>





                <tr>

                              <td width="2%">&nbsp;</td>

                              <td width="96%"> 

                                <table width="100%" border="0" cellspacing="5" cellpadding="1">

                      <tr align="left" valign="top">

                        <td height="8"  colspan="3">&nbsp; </td>

                      </tr>

                      <tr align="left" valign="top">

                        <td height="8" valign="middle" colspan="3">

                          <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)||(iCommand==Command.EDIT)||(iCommand==Command.ASK) || (iCommand==Command.SAVE && iErrCode!=FRMMessage.NONE)){%>

                                      <a name="go"></a>

                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">

                                      <%if (iCommand ==Command.ADD){%>

                                      <tr align="left" valign="top">

                                          <td height="21" valign="middle" width="17%"><b>New Country

                                            </b></td>

                                          <td height="21" colspan="2" width="83%" class="comment">&nbsp;</td>

                                        </tr>

                                        <%}%>

                                        <%if (iCommand ==Command.EDIT){%>

                                      <tr align="left" valign="top">

                                          <td height="21" valign="middle" width="17%"><b>Country

                                            Editor</b></td>

                                          <td height="21" colspan="2" width="83%" class="comment">&nbsp;</td>

                                        </tr>

                                        <%}%>



                                        <tr align="left" valign="top">

                                          <td height="21" valign="middle" width="17%">&nbsp;</td>

                                          <td height="21" colspan="2" width="83%" class="comment">*)=

                                            required</td>

                                        </tr>

                                        <tr align="left" valign="top">

                                          <td height="21" valign="top" width="17%">Country

                                            Code </td>

                                          <td height="21" colspan="2" width="83%">

                                            <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_ID_CODE] %>"  value="<%= country.getIdCode() %>" class="formElemen" size="7">

                                            * <%= frmCountry.getErrorMsg(FrmCountry.FRM_FIELD_ID_CODE) %> 

                                        <tr align="left" valign="top"> 

                                          <td height="21" valign="top" width="17%">Country 

                                            Name</td>

                                          <td height="21" colspan="2" width="83%"> 

                                            <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_COUNTRY_NAME] %>"  value="<%= country.getCountryName() %>" class="formElemen" size="30">

                                            * <%= frmCountry.getErrorMsg(FrmCountry.FRM_FIELD_COUNTRY_NAME) %> 

                                        <tr align="left" valign="top"> 

                                          <td height="21" valign="top" width="17%">Capital 

                                            City</td>

                                          <td height="21" colspan="2" width="83%"> 

                                            <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_CAPITAL_CITY] %>"  value="<%= country.getCapitalCity() %>" class="formElemen" size="30">

                                        <tr align="left" valign="top"> 

                                          <td height="21" valign="top" width="17%">Continent</td>

                                          <td height="21" colspan="2" width="83%"> 

                                            <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_CONTINENT] %>"  value="<%= (country.getContinent()==null) ? "" : country.getContinent() %>" class="formElemen" size="30">

                                        <tr align="left" valign="top"> 

                                          <td height="21" valign="top" width="17%">Time 

                                            To Gmt</td>

                                          <td height="21" colspan="2" width="83%"> 

                                            <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_TIME_TO_GMT] %>"  value="<%= country.getTimeToGmt() %>" class="formElemen" size="5">

                                            <%= frmCountry.getErrorMsg(FrmCountry.FRM_FIELD_TIME_TO_GMT) %> 

                                        <tr align="left" valign="top"> 

                                          <td height="21" valign="top" width="17%">Currency</td>

                                          <td height="21" colspan="2" width="83%"> 

                                            <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_CURRENCY] %>"  value="<%= country.getCurrency() %>" class="formElemen" size="25">

                                            <!--tr align="left" valign="top"> 

                              <td height="21" valign="top" width="17%">Currency 

                                Rate to Rp.</td>

                              <td height="21" colspan="2" width="83%"> 

                                <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_RATE_TO_RP] %>"  value="<%= country.getRateToRp() %>" class="formElemen" size="5">

                                <%= frmCountry.getErrorMsg(FrmCountry.FRM_FIELD_TIME_TO_GMT) %> 

								</tr-->

                                        <tr align="left" valign="top"> 

                                          <td height="21" valign="top" width="17%">Nationality</td>

                                          <td height="21" colspan="2" width="83%"> 

                                            <input type="text" name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_NATIONALITY] %>"  value="<%= (country.getNationality()==null) ? "" : country.getNationality() %>" class="formElemen" size="25">

                                            * <%= frmCountry.getErrorMsg(FrmCountry.FRM_FIELD_NATIONALITY) %> 

                                        <tr align="left" valign="top"> 

                                          <td height="21" valign="top" width="17%">Description</td>

                                          <td height="21" colspan="2" width="83%"> 

                                            <textarea name="<%=frmCountry.fieldNames[FrmCountry.FRM_FIELD_DESCRIPTION] %>" class="formElemen" cols="40" rows="3"><%= (country.getDescription()==null) ? "" : country.getDescription() %></textarea>

                                        <tr align="left" valign="top"> 

                                          <td height="8" valign="middle" width="17%">&nbsp;</td>

                                          <td height="8" colspan="2" width="83%">&nbsp; 

                                          </td>

                                        </tr>

                                        <tr align="left" valign="top" > 

                                          <td colspan="3" class="command"> 

                                            <%

									ctrLine.setLocationImg(approot+"/images/ctr_line");

									ctrLine.initDefault();

									ctrLine.setTableWidth("80%");

									String scomDel = "javascript:cmdAsk('"+oidCountry+"')";

									String sconDelCom = "javascript:cmdConfirmDelete('"+oidCountry+"')";

									String scancel = "javascript:cmdEdit('"+oidCountry+"')";

									ctrLine.setBackCaption("Back to List");

									ctrLine.setCommandStyle("buttonlink");

									ctrLine.setSaveCaption("Save Data");

									ctrLine.setDeleteCaption("Delete Data");



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

                                            <%= ctrLine.drawImage(iCommand, iErrCode, msgString)%> </td>

                                        </tr>

                                        <tr> 

                                          <td width="13%">&nbsp;</td>

                                          <td width="87%">&nbsp;</td>

                                        </tr>

                                        <tr align="left" valign="top" > 

                                          <td colspan="3"> 

                                            <div align="left"></div>

                                          </td>

                                        </tr>

                                      </table>

                          <%}%>

                        </td>

                      </tr>

                    </table>

                  </td>

                              <td width="2%">&nbsp;</td>

                </tr>

                <tr> 

                              <td width="2%">&nbsp;</td>

                              <td width="96%">&nbsp;</td>

                              <td width="2%">&nbsp;</td>

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

