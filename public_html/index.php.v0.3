<?php 
include_once('/opt/dxrfd/public_html/configuration.php'); 

$datafile = '/opt/dxrfd/public_html/data.json';

if (file_exists($datafile) && is_readable($datafile)) {
        fopen($datafile, r);
        $values = file_get_contents($datafile, r);
        $arr_data = json_decode($values, true);

	/* OUTPUT ON ERROR */ 
        switch(json_last_error()) {
        case JSON_ERROR_NONE:
            echo '';
        break;
        case JSON_ERROR_DEPTH:
            echo ' - Maximale Stacktiefe überschritten';
        break;
        case JSON_ERROR_STATE_MISMATCH:
            echo ' - Unterlauf oder Nichtübereinstimmung der Modi';
        break;
        case JSON_ERROR_CTRL_CHAR:
            echo ' - Unerwartetes Steuerzeichen gefunden';
        break;
        case JSON_ERROR_SYNTAX:
            echo ' - Syntaxerror, ungültiges JSON';
        break;
        case JSON_ERROR_UTF8:
            echo ' - Missgestaltete UTF-8 Zeichen, möglicherweise fehlerhaft kodiert';
        break;
        default:
            echo ' - Unknown Error';
        break;
        }
	
	/* FOR DEBUG ONLY */
        //echo "<pre>";
        //echo $values;
        //echo "</pre>";
        //echo "<pre>";
        //print_r($arr_data);
        //echo "</pre>";
} else {
    echo '<br /><br /><br /><div class="alert alert-danger" role="alert">Error, no data found! Maybe '. $datafile . ' is missing or empty.</div>';
	}

?>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="author" content="Jean Gervers DO4IX">
    <meta name="content-language" content="en">
    <meta name="publisher" content="Jean Gervers">
    <meta name="copyright" content="Jean Gervers">
    <meta name="description" content="XRF423 Dashboard">
    <meta name="keywords" content="XRF423, Dashboard, D-Star, DO4IX, Reflector">
    <meta name="page-topic" content="XRF423, Dashboard, D-Star">
    <meta name="page-type" content="XRF423, Dashboard, D-Star">
    <meta name="audience" content="all">
    <meta name="robots" content="index,follow">
    <meta name="classification" content="private">
    <meta name="allow-search" content="yes">
    <meta name="searchtitle" content="XRF423 Dashboard">
    <meta name="revisit-after" content="3 days">
    <meta name="abstract" content="XRF423 Dashboard">
    <meta http-equiv="cache-control" content="no-cache">
    <meta name="date" content="2015-10-27">


	<meta http-equiv="refresh" content="59"/>

    <link rel="icon" href="favicon.ico">

    <title><?php echo PAGETITLE; ?></title>

    <!-- Bootstrap core CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.5/yeti/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="jumbotron.css" rel="stylesheet">



    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>

    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#"><?php echo PAGETITLE; ?><small><?php echo SUBTITLE; ?></small></a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
	<?php
        if (defined('TOPBUTTON1TEXT')) { echo '<li><a class="" href="'. TOPBUTTON1LINK .'" title="'. TOPBUTTON1TEXT .'">'. TOPBUTTON1TEXT . '</a></li>'; }
        if (defined('TOPBUTTON2TEXT')) { echo '<li><a class="" href="'. TOPBUTTON2LINK .'" title="'. TOPBUTTON2TEXT .'">'. TOPBUTTON2TEXT . '</a></li>'; }
        if (defined('TOPBUTTON3TEXT')) { echo '<li><a class="" href="'. TOPBUTTON3LINK .'" title="'. TOPBUTTON3TEXT .'">'. TOPBUTTON3TEXT . '</a></li>'; }
        if (defined('TOPBUTTON4TEXT')) { echo '<li><a class="" href="'. TOPBUTTON4LINK .'" title="'. TOPBUTTON4TEXT .'">'. TOPBUTTON4TEXT . '</a></li>'; }
        if (defined('TOPBUTTON5TEXT')) { echo '<li><a class="" href="'. TOPBUTTON5LINK .'" title="'. TOPBUTTON5TEXT .'">'. TOPBUTTON5TEXT . '</a></li>'; }
        if (defined('TOPBUTTON6TEXT')) { echo '<li><a class="" href="'. TOPBUTTON6LINK .'" title="'. TOPBUTTON6TEXT .'">'. TOPBUTTON6TEXT . '</a></li>'; }
        if (defined('TOPBUTTON7TEXT')) { echo '<li><a class="" href="'. TOPBUTTON7LINK .'" title="'. TOPBUTTON7TEXT .'">'. TOPBUTTON7TEXT . '</a></li>'; }
        if (defined('TOPBUTTON8TEXT')) { echo '<li><a class="" href="'. TOPBUTTON8LINK .'" title="'. TOPBUTTON8TEXT .'">'. TOPBUTTON8TEXT . '</a></li>'; }
        if (defined('TOPBUTTON9TEXT')) { echo '<li><a class="" href="'. TOPBUTTON9LINK .'" title="'. TOPBUTTON9TEXT .'">'. TOPBUTTON9TEXT . '</a></li>'; }
        ?>
          </ul>
        </div><!--/.navbar-collapse -->
      </div>
    </nav>

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
        <h1>INFO</h1>
        <?php echo INFOTEXT; ?>
        <p><a class="btn btn-primary btn-lg" href="D-Star_Praesentation.pdf" role="button">DO6FC D-Star Pr&auml;sentation &raquo;</a></p>
      </div>
    </div>

    <div class="container">
	<div class="row">
		<h1>Linked Gateways</h1>
		<?php 
		foreach($arr_data['Linked Gateways'] as $key=>$value){
		echo '<div class="col-sm-3">';
			echo '<div class="list-group">';
			
				if (count($value)==1){	
				echo '<a href="#" class="list-group-item active"><strong>Module&nbsp;'.$key.'</strong><span class="badge">'.count($value).' Station</span></a>';
				}
				elseif (count($value)>1){
				echo '<a href="#" class="list-group-item active"><strong>Module&nbsp;'.$key.'</strong><span class="badge">'.count($value).' Stations</span></a>';
				}
				else {
				echo '<a href="#" class="list-group-item active"><strong>Module&nbsp;'.$key.'</strong><span class="badge">No Station</span></a>';
				echo '<a href="#" class="list-group-item">Not in use</a>';
				}


				foreach($value as $call){
				echo '<a href="'. CALLSIGNDB .'/'.$call['Callsign'].'" class="list-group-item" target="_blank" title="Show Details">'.$call['Callsign'].'</a>';
				}
			
			echo '</div>';
		echo '</div>';
		echo '<!-- Add the extra clearfix for only the required viewport -->';
		echo '<div class="clearfix visible-xs-block"></div>';
		}


		?>		


		<!-- Add the extra clearfix for only the required viewport -->
		<div class="clearfix visible-xs-block"></div>


	</div><!-- row -->


	<div class="row">
		<h1>Software Clients</h1>
		<div class="col-sm-6 col-sm-offset-2">
		<table class="table table-striped">
			<th>#</th><th>Callsign</th><th>Module</th><th>Type</th>
			<?php 
			$iSC = 0;
			foreach ($arr_data['Software Clients']['sitem'] as $row){
			echo "<tr><td>".++$iSC."</td><td>".$row['Callsign']."</td><td>".$row['Module']."</td><td>".$row['Type']."</td></tr>";
			}
			?>
		</table>
		</div>
	</div>

	<div class="row">
		<h1>Last Heard <br><small>at <?php echo date("d.m.Y H:i", time()); ?> local Time</small></h1>
		<div class="col-sm-6 col-sm-offset-2">
		<table class="table table-striped">
			<th>Local Date&Time</th><th>Callsign</th><th>Last TX on</th><th>Source</th>
			<?php 
			foreach ($arr_data['Last Heard']['litem'] as $row){
			echo "<tr><td>".$row['DateTime']."</td><td><a href=\"http://www.qrz.com/db/".$row['Callsign']."\">".$row['Callsign']."</td><td>".$row['Last TX on']."</td><td>".$row['Source']."</td></tr>";
			}
			?>
		</table>
		</div>
	</div>

	<div class="row">
		<h1>Server Status</h1>
		<div class="col-sm-6 col-sm-offset-2">

			<div class="panel panel-default">
				<div class="panel-heading">Technical Informations</div>
				<div class="panel-body">
					
				<?php
			
					#echo 'The Server is owned by '. SYSOPCALL .', '. SYSOPNAME .'.';
					echo 'The Server is owned by <a href="http://www.qrz.com/db/'.SYSOPCALL.'">'.SYSOPCALL.'</a>, '. SYSOPNAME .'.';
					$uptime = shell_exec("cut -d. -f1 /proc/uptime");
					$days = floor($uptime/60/60/24);
					$hours = $uptime/60/60%24;
					$mins = $uptime/60%60;
					$secs = $uptime%60;
					echo "<br>This server is up and running for $days days $hours hours $mins minutes and $secs seconds.";
					
					$load = sys_getloadavg();
					echo "<br>The Server load in the last 5 min is:&nbsp;" .$load[0];
					if ($load[0] > 80) {
					    header('HTTP/1.1 503 Too busy, try again later');
					    die('Serverlast zu hoch, versuchen Sie es später noch einmal.');
						}
				?>

				</div>
			</div>
		</div>
	</div>

</div><!-- container -->

      <hr>
      <footer>
        <p><a href="impressum.html">Impressum</a><?php echo FOOTERTEXT; ?></p>
      </footer>
    </div> <!-- /container -->


    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="http://getbootstrap.com/assets/js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>
