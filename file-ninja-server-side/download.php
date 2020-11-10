<?php
error_reporting(0);
$token_id = htmlentities(addslashes($_GET["token"]));

if($token_id == ""){
    die("Please enter a valid code.");
}

require_once("connect.php");
$queryString = "SELECT * FROM files WHERE token_id='".$token_id."' ORDER BY timestamp DESC";
$query = mysqli_query($conn, $queryString);

$files = array();

if(mysqli_num_rows($query) > 0){
    $latest = mysqli_fetch_assoc($query);
    $minutesPassed = (int) (time() - strtotime($latest["timestamp"])) / 60;
    
    if(floor($minutesPassed) < 30){
        $files[] = getPathFromURL($latest["file_url"]);
        while($other = mysqli_fetch_assoc($query)){
            $files[] = getPathFromURL($other["file_url"]);
        }

    }else{
        die("The file is no longer available.");
    }
}else{
    die("The code is not correct. Please try again!");
}

mysqli_close($conn);

require_once("fpdf/fpdf.php");
$pdf = new FPDF();
$pdf->SetAutoPageBreak(FALSE);
$files = array_reverse($files);
foreach($files as $image){
    list($w, $h) = getimagesize($image);
    $w = (2.54/96) * $w;
    if($w > 21){
        $image = compressIMG($image, floor(21 * (96/2.54)), true);
    }

    list($w, $h) = getimagesize($image);
    $h = (2.54/96) * $h;
    if($h > 29.7){
        $image = compressIMG($image, true, floor(29.7 * (96/2.54)));
    }
    $pdf->AddPage();
    $pdf->Image($image, 0, 0);
}
$pdf->Output('D', $token_id . '.pdf');

function compressIMG($file, $width, $height) {
    $extension = exif_imagetype($file);

    $image = NULL;
    if ($extension == 2){
        $extension = "jpg";
    	$image = imagecreatefromjpeg($file);
    }else if($extension == 3){
        $extension = "png";
    	$image = imagecreatefrompng($file);
    }else {
    	return false;
    }
    
    $height = $height === true ? (imagesy($image) * $width / imagesx($image)) : $height;
    $width = $width === true ? (imagesx($image) * $height / imagesy($image)) : $width;
    
    $output = imagecreatetruecolor($width, $height);
    imagecopyresampled($output, $image, 0, 0, 0, 0, $width, $height, imagesx($image), imagesy($image));
    
    $newFilePath = "images/upload/" . pathinfo($file, PATHINFO_FILENAME) . "compressed" . ".jpg";
    imagejpeg($output, $newFilePath, 100); 
    return $newFilePath;
}

function getPathFromURL($url){
    $parsed = parse_url($url, PHP_URL_PATH);
    return "images/upload/" . basename($parsed);
}
?>