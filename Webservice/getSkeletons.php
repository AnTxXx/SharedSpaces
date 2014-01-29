<?php
/**
 * Liefert die aktuellen Positoinsdaten als JSON
 */
require 'api.php';


$api = new SpacesAPI;
$api->getAllSkeletons();

?>