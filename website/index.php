<?
function httpPost($url, $data){
  $curl = curl_init($url);
  curl_setopt($curl, CURLOPT_POST, true);
  curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($data));
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
  $response = curl_exec($curl);
  curl_close($curl);
  return $response;
}

$URL_API_PRODUCTS = "http://host.docker.internal:9001/products";
//$URL_API_PRODUCTS = "http://node-container:9001/products";
//$URL_API_PRODUCTS = "http://localhost:9001/products";

if(!empty($_POST['btnSubmit'])){
  $dataPost = ['name' => $_POST['name'], 'price' => $_POST['price']];
  $dataQuery = http_build_query($dataPost); // WTF POST isn't working, so data goes by query 
  $result_post = httpPost("$URL_API_PRODUCTS?$dataQuery", $dataPost);
}

$result = file_get_contents($URL_API_PRODUCTS);
$products = json_decode($result);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Docker Introduction</title>
    <link rel="stylesheet" href="vendor/bootstrap/css/bootstrap.min.css">
</head>
<body>
    <br>
    <div class="container">
        <form action="" method="POST">
            <b>Product:</b> <input type="text" name="name" value="">
            <b>Price:</b> <input type="text" name="price" value="">
            <input type="submit" name="btnSubmit">
        </form>
    </div>
    <hr>
    <div class="container">
        <table class="table">
        <thead>
            <tr>
                <th>Product</th>
                <th>Price</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach($products as $product): ?>
            <tr>
                <td><?php echo $product->name;?></td>
                <td><?php echo $product->price;?></td>
            </tr>
            <?php endforeach; ?>
        </tbody>
        </table>
    </div>

</body>
</html>