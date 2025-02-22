<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>VIP值班-Java互助学习VIP群业务运行系统</title>
<link href="${pageContext.request.contextPath}/tableTemplet/css/H-ui.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/tableTemplet/lib/Hui-iconfont/1.0.1/iconfont.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/jslib/jquery-1.11.1.min.js"></script>	

<script type="text/javascript" src="${pageContext.request.contextPath}/jslib/jquery-1.11.1.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/layer/layer-v2.0/layer/layer.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/jslib/myfile.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/tableTemplet/lib/jquery/1.9.1/jquery.min.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/tableTemplet/lib/My97DatePicker/WdatePicker.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/tableTemplet/lib/datatables/1.10.0/jquery.dataTables.min.js"></script> 
<script type="text/javascript">
var url1 = "/onduty/query.action";
var url2 = "/onduty/getbyname.action";
var url3= "/onduty/getAll.action";
var page1;
function drawTable(data,navbar){
	if(data==""){
		return;	
	}
	var status="";
	var line="";
	line=line + "<thead>";
	line=line + "<tr class='text-c'>";
	line=line + "<th>序号</th>";
	line=line + "<th>会员姓名</th>";
	line=line + "<th>值班日期</th>";	
	line=line + "<th>开始时间</th>";	
	line=line + "<th>结束时间</th>";
	line=line + "<th>申请时间</th>";	
	line=line + "<th>审核状态</th>";
	line=line + "<th>审核时间</th>";
	line=line + "<th width='120px'>操作</th>";
	line=line + "</tr>";
	line=line + "</thead>";
	line=line + "<tbody>";
	for(i=0;i<data.length;i++){
		//alert(data[i].id)
		var flag=data[i].flag;
		var read=data[i].read;
		line=line + "<tr class='text-c'>";			
		line=line + "<td>" + (i+1) + "</td>";
		line=line + "<td>"+data[i].name+"</td>";
		var start = data[i].start.split(" ");
		line=line + "<td>"+start[0]+"</td>";
		line=line + "<td>"+start[1]+"</td>";
		var end = data[i].end.split(" ");
		line=line + "<td>"+end[1]+"</td>";
		line=line + "<td>"+data[i].time+"</td>";
		line=line + "<td class='td-status'><a herf='#' class='flag' lang='"+data[i].id+"'>" + show(flag) + "</a></td>";
		line=line + "<td>"+time(read)+"</td>";
		line=line + "<td class='f-14 td-manage'><a herf='#' title='审核' style='text-decoration:none' class='log' lang='"+data[i].id+"'><i class='Hui-iconfont'>&#xe623;</i></a>┆&nbsp;&nbsp;<a herf='#' title='查看' style='text-decoration:none' class='look' lang='"+data[i].id+"'><i class='Hui-iconfont'>&#xe623;</i></a>┆&nbsp;&nbsp;<a herf='#' title='删除' style='text-decoration:none' class='del' lang='"+data[i].id+"'><i class='Hui-iconfont'>&#xe609;</i></a></td>";
		line=line + "</tr>";	
	}
	line=line + "</tbody>";
	$("#onduty").html(line);
	$("#navbar").html(navbar);
	$(".del").click(function(){
		if(!confirm("确认要删除吗？")){
			return;
		}
		$.post('${pageContext.request.contextPath}/onduty/del.action',{id:this.lang},function(){
			//query(url1);
			showAll(page1);
		});
	});
	$(".log").one("click",function(){
		var e=$(this);
		e.html("");
		var l = this.lang
		changeflag(e,l,url3);
	});
	$(".look").one("click",function(){
		var e=$(this);
		layer.open({
			  type: 2,
			  title: '查看值班日志',
			  area: ['800px', '500px'],
			 // closeBtn: 0, //不显示关闭按钮
			  shift: 1,
			  maxmin: true,
			  shade: 0.5, //开启遮罩关闭
			  content: "${pageContext.request.contextPath}/onduty/showlogs.jsp?oid=" + this.lang + "&type=admin",
			  end: function(){
			    }
			});
	});
	$(".nav-btn").click(function(){
		page2=this.lang;
		page1=this.lang;
		showAll(page2,$("[name='mname2']").val(),$("#logmin").val(),$("#logmax").val());
	});
}
//提取数据
function getData(page,name,start,end){
	var status="";
	$.post("${pageContext.request.contextPath}/onduty/getAll.action",{page2:page,uname:name,start:start,end:end},function(data){
	var dataObj = eval("("+data+")");
	var navbar=dataObj.returnMap.navbar;
	var tatolCount=dataObj.returnMap.totalCount;
	var list=dataObj.returnMap.list;
	drawTable(list,navbar);
	})
	
}
//设置flag
function changeflag(e,l,url){
	var line="";
	line = line + "<select style='width:90px;height:26px;margin:0px;' name='change' onchange='select("+$(this)+","+l+")'>";
	line = line + "<option value='0'>-请选择-</option>";
	line = line + "<option value='1'>通过</option>";
	line = line + "<option value='-1'>不通过</option>";
	line = line + "</select>";
	e.append(line);
	$('[name=change]').change(function(){
		select($(this),l,url);
	});
}
function query(url){
	$("#info").html("");
	var start = $("[name='date1']").val();
	var end =  $("[name='date2']").val();
	var type = $("[name='type']").val();
	$("#onduty").html("");
	$.post("${pageContext.request.contextPath}/onduty/getAll.action",{start:start,end:end,type2:type},function(data){
		var dataObj = eval("("+data+")");
		var navbar=dataObj.returnMap.navbar;
		var tatolCount=dataObj.returnMap.totalCount;
		var list=dataObj.returnMap.list;
		drawTable(list,navbar);
	});
}
//显示所有值班日志
function showAll(page,name,start,end){
	getData(page,name,start,end);
}
//将flag设置为1
function select(e,l,url){	
	if(e.val()==0){
		query(url);
	}
	//$.post('${pageContext.request.contextPath}/onduty/del.action',{id:l,flag:e.val()},function(){
	//},'json');
	$.post('${pageContext.request.contextPath}/onduty/setFlag.action',{oid:l},function(){
	},'json');
	showAll(page1);
}
function selection(data,f,T){
	f.html("");
	var line="";
	if(T==1){
		$("#append2").css("display","");
		line = line + "<select class='select' name='mname1'>";
	}else if(T==2){
		$("#append2").css("display","");
		line = line + "<select class='select' name='mname2'>";
	}
	line = line + "<option value='0'>选择会员编号</option>";
	for(var i=0;i<data.length;i++){
		line = line + "<option value='"+data[i]+"'>"+data[i]+"</option>";
	}
	line = line + "</select>";
	f.append(line);
}
function check(e,f){
	var a = e.split(":");
	var b = f.split(":");
	var c = b[0]-a[0];
	var d = b[1]-a[1];
	if(d>0){
		if(c>=2&&c<4)
			return 1;
	}else if(d<0){
		if(c>=3&&c<5)
			return 1;
	}else{
		if(c>=2&&c<=4)
			return 1;
	}
}
function show(flag){
	if(flag==1){
		status="<span class='label label-success radius'>已通过</span>";
	}else if(flag==-1){
		status="<span class='label label-warning radius'>不通过</span>";
	}else{
		status="<span class='label label-danger radius'>未审核</span>";
	}
	return status;
}
function time(read){
	if(read==null){
		read="";
	}
	return read;
}
function checkname(e,f,T){
	$("#info").html("");
	var name=e.val().trim();
	if(name==""){
		$("#info").html("*请输入会员姓名后再进行操作");
		return;
	}
	$.post('${pageContext.request.contextPath}/onduty/checkName.action',{name:name},function(data){
		if(data.length>0){
			selection(data,f,T);
			return 1;
		}else{
			$("#info").html("*不存在该会员!请检查后重新输入");
			return 0;
		}
	});
}
/**
 * 太乱了，一开始就应该备注，现在懒得回去备注了。
 *下次得注意规范命名.
 */
$(function(){
	var page=1;
	$.ajaxSetup({
		  async: false
	});
	showAll(page);
	//$.post("${pageContext.request.contextPath}/onduty/query.action",{start:"",end:""},function(data){
	//	drawTable(data,url1);
	//});
	/**
	*这里是增加值班信息，直接有效.
	*/
	$("#add").click(function(){
		$("#info").html("");
		var starttime=$("[name='starttime']").val();
		var endtime=$("[name='endtime']").val();
		var date = $("[name='startdate']").val();
		if(starttime==""||endtime==""||date==""){
			$("#info").html("*请选择值班时间后再进行提交");
			return;
		}
		var status = check(starttime,endtime);
		if(!status==1){
			$("#info").html("*每次值班时间不少于两个小时且不能超过四个小时");
			return;
		}
		if($("#name1").val().trim()==""){
			$("#info").html("*请输入会员姓名后再进行操作");
			return;
		}
		var uname=$("[name='mname1']").val();
		if(uname==0){
			$("#info").html("*请选择会员编号");
			return;
		}
		starttime = date+" "+starttime;
		endtime = date+" "+endtime;
		alert($("[name='mname2']").val());
		$.post('${pageContext.request.contextPath}/onduty/add.action',{"start":new Date(starttime),"end":new Date(endtime),"uname":uname},function(){
		},"json");
	});
	/**
	*这里是根据时间段和类型回调数据.
	*/
	$("#query").click(function(){
		query(url1);
	});
	/**
	*这里是隐藏或弹出窗口.
	*/
	$("#set").click(function(){
		if($("#hha").css("display")!="none"){
			$("#hha").css("display","none");
		}else{
			$("#hha").css("display","");		
		}
	});
	/**
	*这里是输入会员姓名后回调会员编号以防同名.
	*/
	$("#name1").blur(function(){
		var T=1;
		var f=$("#append1");
		var e=$("#name1");
		checkname(e, f,T);
	});
	$("#name2").blur(function(){
		var T=2;
		var f=$("#append2");
		var e=$("#name2");
		checkname(e, f,T);
	});
	/**
	*这里是根据会员姓名查询申请记录(暂不支持其他限定条件查询).
	*/
	$("#get").click(function(){
		$("#logmin").val("");
		$("#logmax").val("");
		if($("#name2").val().trim()==""){
			$("#info").html("*请输入会员姓名后再进行操作");
			return;
		}
		var uname=$("[name='mname2']").val();
		if(uname==0){
			$("#info").html("*请选择会员编号");
			return;
		}
		if(uname!=0){
			$("#info").html("");
		}
		$("#onduty").html("");
		$.post('${pageContext.request.contextPath}/onduty/getAll.action',{page2:1,uname:uname},function(data){
			//drawTable(data,url2);
			var dataObj = eval("("+data+")");
			var navbar=dataObj.returnMap.navbar;
			var tatolCount=dataObj.returnMap.totalCount;
			var list=dataObj.returnMap.list;
			drawTable(list,navbar);
		})
	});
	$("#auditing").click(function() {
		layer.open({
			title: '批量审核值班记录',
			type: 2,
			area: ['700px', '530px'],
			fixed: false, //不固定
			maxmin: true,
			content: '${pageContext.request.contextPath}/admin/auditduty.jsp'
		});
	});
});
</script>



</head>
<body>


<%--<c:if test="${admin==null}">
	<jsp:forward page="../user/login.jsp"></jsp:forward>
	</c:if> --%>
<div class="pd-20">
	<div class="text-c">
	选择查看日期：
    <input type="text" name="date1" id="logmin" class="span2 input-text Wdate" onfocus="WdatePicker({maxDate:'#F{$dp.$D(\'logmax\')||\'%y-%M-%d\'}'})" style="width:120px;">
    -
    <input type="text" name="date2" id="logmax" class="span2 input-text Wdate" onfocus="WdatePicker({minDate:'#F{$dp.$D(\'logmin\')}',maxDate:'%y-%M-%d'})" style="width:120px;">
    值班信息：
	<span class="select-box inline">
    <select class="select" name="type">
		<option value="0">未审核</option>
		<option value="1">全部</option>
	</select>
    </span>
    <button id="query" class="btn btn-success" type="submit"><i class="Hui-iconfont">&#xe665;</i>查询</button>
    <button id="set" class="btn" type="submit">添加值班</button>
	<br>
    <br>
输入会员姓名：
<input type="text" class="span2 input-text" id="name2" style="width:120px;">
<span id="append2" class="select-box inline" style="display:none;"></span>
<button id="get" class="btn" type="submit">查找</button>
</div>
</div>
<div style="display:none; text-align:center" id="hha">
选择值班时间：
<input type="text" class="span2 input-text Wdate" name="startdate" id="startdate"  readonly="readonly"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" style="width:120px;">
<input type="text" class="span1 span2 input-text Wdate" readonly name="starttime" id="starttime"  onfocus="WdatePicker({dateFmt:'H:mm',minDate:'8:30',maxDate:'21:30',onpicked:function(){endtime.focus()} })" style="width:120px;">
~
<input type="text" class="span1 span2 input-text Wdate" readonly name="endtime" id="endtime"  onfocus="WdatePicker({dateFmt:'H:mm',minDate:'10',maxDate:'23:30'})" style="width:120px;">
会员姓名：
<input type="text" class="span2 input-text" id="name1" style="width:120px;">
<button id="add" class="btn" type="submit">添加</button>
</div>
<div id="info" style="margin-left:20px; padding-left:200px;"></div>
<div class="pd-20">
<div class="mt-20">
<p><input type="button" id="auditing" value="批量审核" class="btn btn-danger radius auditing"></p>
<table id="onduty" class="table table-border table-bg table-bordered radius">
</table>
</div>
</div>
<br>
<div align="center" id="navbar"></div>
</body>
</html>


