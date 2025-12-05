try {
    // 1. Parse the Main Response (Product Data)
    var mainResponse = JSON.parse(context.getVariable("response.content"));

    // 2. Parse the Side-Call Response (Inventory Data)
    var inventoryResponse = JSON.parse(context.getVariable("inventoryResponse.content"));

    // 3. Create the Merged Object
    // CORRECTION: The mock target returns flat JSON, so we remove ".root"
    var merged = {
        "meta": {
            "api": "Retail Mesh v1",
            "timestamp": new Date().toISOString()
        },
        "product": {
            "id": mainResponse.firstName, // Access directly
            "name": mainResponse.lastName // Access directly
        },
        "availability": {
            "location": inventoryResponse.city, // Access directly
            "status": "In Stock"
        }
    };

    // 4. Overwrite the Final Response
    context.setVariable("response.content", JSON.stringify(merged));
    context.setVariable("response.header.Content-Type", "application/json");

} catch (e) {
    var error = {
        "error": "MashupFailed",
        "detail": e.message
    };
    context.setVariable("response.content", JSON.stringify(error));
    context.setVariable("response.status.code", 500);
}
