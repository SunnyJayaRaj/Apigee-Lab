try {
    // 1. Parse the Main Response (Product Data)
    // context.getVariable reads the standard response body
    var mainResponse = JSON.parse(context.getVariable("response.content"));

    // 2. Parse the Side-Call Response (Inventory Data)
    // We explicitly call out the variable 'inventoryResponse' we created earlier
    var inventoryResponse = JSON.parse(context.getVariable("inventoryResponse.content"));

    // 3. Create the Merged Object
    var merged = {
        "meta": {
            "api": "Retail Mesh v1",
            "timestamp": new Date().toISOString()
        },
        "product": {
            "id": mainResponse.root.firstName, // Using mock data field as ID
            "name": mainResponse.root.lastName // Using mock data field as Name
        },
        "availability": {
            "location": inventoryResponse.root.city,
            "status": "In Stock"
        }
    };

    // 4. Overwrite the Final Response
    // We convert our object back to a JSON string
    context.setVariable("response.content", JSON.stringify(merged));
    context.setVariable("response.header.Content-Type", "application/json");

} catch (e) {
    // Safety Net: If JSON parsing fails, return a clean error
    var error = {
        "error": "MashupFailed",
        "detail": e.message
    };
    context.setVariable("response.content", JSON.stringify(error));
    context.setVariable("response.status.code", 500);
}
