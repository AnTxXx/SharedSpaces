<?php
 
class SpacesAPI {
    private $db;
 
    // Constructor - open DB connection
    function __construct() {
        //$this->db = new mysqli('localhost', 'root', '', 'btd_webservice');
        $this->db = new mysqli('mysqlsvr34.world4you.com', 'sql2919695', 'a43nt9r', '2919695db1');
        $this->db->autocommit(FALSE);
    }
 
    // Destructor - close DB connection
    function __destruct() {
        $this->db->close();
    }


    // Main method to redeem a code
    function getAllSkeletons() {   	
    	
    	
    	$tstamp = gmdate('Y-m-d H:i:s', (strtotime("now") + 3580));
    	$query = 'SELECT client_ID, skeleton_ID, xPos, zPos, orientation, tstamp FROM skeletons WHERE tstamp > \'' . $tstamp . '\'';
     	echo $query;
    	
    	$stmt = $this->db->prepare($query);
    	$stmt->execute();
    	$stmt->bind_result($client_ID, $skeleton_ID, $xPos, $zPos, $orientation, $tstamp);
    
    	$json_result = array();
    	$skeleton_ii = 1;
    
    	/* Dirty Hack
    	 * due to a request of (bad) Michael
    	* always add client 1 & 2 to array
    	*/
    	$json_result["client_ID1"]=array();
    	$json_result["client_ID2"]=array();
    
    
    	while ($stmt->fetch()) {
    
    		$name = "client_ID" . strval($client_ID);
    		 
    		if(empty($json_result[$name])) {
    			$json_result[$name]=array();
    			$skeleton_ii=1;
    		}
    
    		$json_result[$name]["skeleton_ID" . $skeleton_ii] = array("skeleton_ID" => $skeleton_ID, "xPos" => $xPos, "zPos" => $zPos, "orientation" => $orientation);
    		$skeleton_ii++;
    	}
    
    
    	$this->sendResponse(200, json_encode($json_result), "application/json");
    	$stmt->close();
    }
        
    
    // Main method to redeem a code
    function stageGetAllSkeletons() {
    	 
    	$query = 'SELECT client_ID, skeleton_ID, xPos, zPos, orientation, tstamp FROM skeletons';
    	//echo $query;
    	 
    	$stmt = $this->db->prepare($query);
    	$stmt->execute();
    	$stmt->bind_result($client_ID, $skeleton_ID, $xPos, $zPos, $orientation, $tstamp);
    
    	$json_result = array();
    	$skeleton_ii = 1;
    
    	/* Dirty Hack
    	 * due to a request of (bad) Michael
    	* always add client 1 & 2 to array
    	*/
    	$json_result["client_ID1"]=array();
    	$json_result["client_ID2"]=array();
    
    
    	while ($stmt->fetch()) {
    
    		$name = "client_ID" . strval($client_ID);
    		 
    		if(empty($json_result[$name])) {
    			$json_result[$name]=array();
    			$skeleton_ii=1;
    		}
    
    		$json_result[$name]["skeleton_ID" . $skeleton_ii] = array("skeleton_ID" => $skeleton_ID, "xPos" => $xPos, "zPos" => $zPos, "orientation" => $orientation);
    		$skeleton_ii++;
    	}
    
    
    	$this->sendResponse(200, json_encode($json_result), "application/json");
    	$stmt->close();
    }
    
    
	function writeSkeletonsToDB() {	
		
		$json['data'] = json_decode(html_entity_decode($_POST['jsonString']),true);
		
		$id = $json['data'][0]["client_ID"];
		
		if($id!='') {
		
			$this->db->query ( "DELETE FROM skeletons WHERE client_ID=$id" );
			$now = gmdate('Y-m-d H:i:s', (strtotime("now")));
			
			foreach ($json['data'] as $skeleton) {
					
				$stmt = $this->db->prepare("INSERT INTO skeletons (client_ID, skeleton_ID, xPos, zPos, orientation) VALUES (?, ?, ?, ?, ?)");
				$stmt->bind_param("iiddd", $skeleton["client_ID"], $skeleton["skeleton_ID"], $skeleton["xPos"], $skeleton["zPos"], $skeleton["orientation"]);
				
				$stmt->execute();		
			}

			$stmt->close();			

		}
		else {
			echo "ERROR: No client id specified!";
		}
	}
    
    function getStatusCodeMessage($status)
    {
    	// these could be stored in a .ini file and loaded
    	// via parse_ini_file()... however, this will suffice
    	// for an example
    	$codes = Array(
    			100 => 'Continue',
    			101 => 'Switching Protocols',
    			200 => 'OK',
    			201 => 'Created',
    			202 => 'Accepted',
    			203 => 'Non-Authoritative Information',
    			204 => 'No Content',
    			205 => 'Reset Content',
    			206 => 'Partial Content',
    			300 => 'Multiple Choices',
    			301 => 'Moved Permanently',
    			302 => 'Found',
    			303 => 'See Other',
    			304 => 'Not Modified',
    			305 => 'Use Proxy',
    			306 => '(Unused)',
    			307 => 'Temporary Redirect',
    			400 => 'Bad Request',
    			401 => 'Unauthorized',
    			402 => 'Payment Required',
    			403 => 'Forbidden',
    			404 => 'Not Found',
    			405 => 'Method Not Allowed',
    			406 => 'Not Acceptable',
    			407 => 'Proxy Authentication Required',
    			408 => 'Request Timeout',
    			409 => 'Conflict',
    			410 => 'Gone',
    			411 => 'Length Required',
    			412 => 'Precondition Failed',
    			413 => 'Request Entity Too Large',
    			414 => 'Request-URI Too Long',
    			415 => 'Unsupported Media Type',
    			416 => 'Requested Range Not Satisfiable',
    			417 => 'Expectation Failed',
    			500 => 'Internal Server Error',
    			501 => 'Not Implemented',
    			502 => 'Bad Gateway',
    			503 => 'Service Unavailable',
    			504 => 'Gateway Timeout',
    			505 => 'HTTP Version Not Supported'
    					);
    
    	return (isset($codes[$status])) ? $codes[$status] : '';
    }
    
    // Helper method to send a HTTP response code/message
    function sendResponse($status = 200, $body = '', $content_type = 'text/html')
    {
    	$status_header = 'HTTP/1.1 ' . $status . ' ' . $this->getStatusCodeMessage($status);
    	header($status_header);
    	header('Content-type: ' . $content_type);
    	echo $body;
    }
}


?>