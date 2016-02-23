<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Status</title>

    <!-- Bootstrap core CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">


    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <div class="container">
      <div class="page-header">
        <h1>XRF Status<small></small></h1>
      </div>
      <p class="lead">Am <?php  echo date('d.m.Y H:i '); ?> waren ingesammt  <b><?php include("anzahl.txt"); ?></b> XRF-Reflectoren bekannt. Davon waren <b><?php include("anzahlonline.txt"); ?></b> online und <b><?php include("anzahloffline.txt"); ?></b> nicht erreichbar. <?php include("anzahldns.txt"); ?> </p> 
    </div>

	<div class="row"><div class="col-sm-6 col-sm-offset-3">
	<div class="panel panel-success">
	<div class="panel panel-heading">Online</div>
	  <div class="panel-body">
		<?php include("xrf_online.txt"); ?>
	  </div>
	</div>	
<hr>
	<div class="panel panel-danger">
	<div class="panel panel-heading">Offline</div>
	  <div class="panel-body">
		<?php include("xrf_offline.txt"); ?>
	  </div>
	</div>	
	</div></div>

	<div class="row"><div class="col-sm-6 col-sm-offset-3">
	<h2>Round Trip Time </h2>
	<hr>
	<center> <?php include_once('images.php'); ?> </center>
	<hr>
	</div> </div>
	
	<br />


    <footer class="footer">
      <div class="container">
        <p class="text-muted"> .....For further information visit our website at www.xrfmaster.net</p>
      </div>
    </footer>


  </body>
</html>
