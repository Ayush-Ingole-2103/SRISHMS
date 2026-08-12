/**
 * SRISHMS Authentication
 */

/* =========================================================
   LOGIN
========================================================= */

async function loginUser(email, password) {

    return await apiRequest(
        "/auth/login",
        {
            method: "POST",

            body: JSON.stringify({
                email: email,
                password: password
            })
        }
    );
}


/* =========================================================
   CURRENT USER
========================================================= */

async function getCurrentUser() {

    return await apiRequest(
        "/auth/me",
        {
            method: "GET"
        }
    );
}


/* =========================================================
   LOGOUT
========================================================= */

async function logoutUser() {

    return await apiRequest(
        "/auth/logout",
        {
            method: "POST"
        }
    );
}


/* =========================================================
   PROTECT PAGE
========================================================= */

async function requireAuthentication() {

    try {

        const response = await getCurrentUser();

        if (
            !response.success ||
            !response.authenticated
        ) {
            window.location.href = "login.html";
            return null;
        }

        return response.data;

    } catch (error) {

        window.location.href = "login.html";
        return null;
    }
}