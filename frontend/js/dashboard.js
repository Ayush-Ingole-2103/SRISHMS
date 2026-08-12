/**
 * SRISHMS Dashboard
 *
 * Loads dashboard data from:
 *
 * GET /api/dashboard
 */


/* =========================================================
   FORMAT CURRENCY
========================================================= */

function formatCurrency(value) {

    return new Intl.NumberFormat(
        "en-IN",
        {
            style: "currency",
            currency: "INR",
            maximumFractionDigits: 0
        }
    ).format(value);
}


/* =========================================================
   LOAD DASHBOARD
========================================================= */

async function loadDashboard() {

    try {

        /*
         * First verify authentication.
         */

        const user =
            await requireAuthentication();


        if (!user) {
            return;
        }


        /*
         * Load dashboard information.
         */

        const response =
            await apiRequest(
                "/dashboard",
                {
                    method: "GET"
                }
            );


        const data =
            response.data;


        /* =====================================================
           USER / STORE
        ===================================================== */

        document.getElementById(
            "userName"
        ).textContent =
            user.full_name;


        document.getElementById(
            "userAvatar"
        ).textContent =
            user.full_name
                .charAt(0)
                .toUpperCase();


        document.getElementById(
            "storeName"
        ).textContent =
            data.store.storeName;


        /* =====================================================
           STATISTICS
        ===================================================== */

        document.getElementById(
            "totalProducts"
        ).textContent =
            data.stats.totalProducts;


        document.getElementById(
            "stockValue"
        ).textContent =
            formatCurrency(
                data.stats.stockValue
            );


        document.getElementById(
            "lowStock"
        ).textContent =
            data.stats.lowStock;


        document.getElementById(
            "outOfStock"
        ).textContent =
            data.stats.outOfStock;


        /* =====================================================
           SALES
        ===================================================== */

        document.getElementById(
            "totalSales"
        ).textContent =
            formatCurrency(
                data.salesSummary.totalSales
            );


        document.getElementById(
            "totalOrders"
        ).textContent =
            data.salesSummary.totalOrders;


        /* =====================================================
           STOCK HEALTH
        ===================================================== */

        document.getElementById(
            "healthyStock"
        ).textContent =
            data.stockHealth.healthy;


        document.getElementById(
            "monitorStock"
        ).textContent =
            data.stockHealth.monitor;


        document.getElementById(
            "slowStock"
        ).textContent =
            data.stockHealth.slowMoving;


        document.getElementById(
            "criticalStock"
        ).textContent =
            data.stockHealth.critical;


        /* =====================================================
           LOW STOCK TABLE
        ===================================================== */

        renderLowStockProducts(
            data.lowStockProducts
        );


    } catch (error) {

        console.error(
            "Dashboard error:",
            error
        );

        alert(
            error.message ||
            "Unable to load dashboard."
        );

    }

}


/* =========================================================
   LOW STOCK TABLE
========================================================= */

function renderLowStockProducts(products) {

    const container =
        document.getElementById(
            "lowStockTable"
        );


    if (
        !products ||
        products.length === 0
    ) {

        container.innerHTML = `
            <p style="color:#6b7280;">
                No low-stock products found.
            </p>
        `;

        return;
    }


    let html = `

        <table
            style="
                width:100%;
                border-collapse:collapse;
            "
        >

            <thead>

                <tr>

                    <th
                        style="
                            text-align:left;
                            padding:12px;
                            border-bottom:1px solid #e5e7eb;
                        "
                    >
                        Product
                    </th>

                    <th
                        style="
                            text-align:left;
                            padding:12px;
                            border-bottom:1px solid #e5e7eb;
                        "
                    >
                        SKU
                    </th>

                    <th
                        style="
                            text-align:left;
                            padding:12px;
                            border-bottom:1px solid #e5e7eb;
                        "
                    >
                        Current Stock
                    </th>

                    <th
                        style="
                            text-align:left;
                            padding:12px;
                            border-bottom:1px solid #e5e7eb;
                        "
                    >
                        Minimum Stock
                    </th>

                </tr>

            </thead>

            <tbody>
    `;


    products.forEach(
        product => {

            html += `

                <tr>

                    <td
                        style="
                            padding:12px;
                            border-bottom:1px solid #f1f5f9;
                        "
                    >
                        ${product.product_name}
                    </td>

                    <td
                        style="
                            padding:12px;
                            border-bottom:1px solid #f1f5f9;
                        "
                    >
                        ${product.sku}
                    </td>

                    <td
                        style="
                            padding:12px;
                            border-bottom:1px solid #f1f5f9;
                            color:#dc2626;
                            font-weight:600;
                        "
                    >
                        ${product.current_stock}
                    </td>

                    <td
                        style="
                            padding:12px;
                            border-bottom:1px solid #f1f5f9;
                        "
                    >
                        ${product.minimum_stock}
                    </td>

                </tr>

            `;

        }
    );


    html += `

            </tbody>

        </table>

    `;


    container.innerHTML = html;
}


/* =========================================================
   LOGOUT
========================================================= */

document
    .getElementById("logoutButton")
    .addEventListener(
        "click",
        async function (event) {

            event.preventDefault();

            try {

                await logoutUser();

                window.location.href =
                    "login.html";

            } catch (error) {

                alert(
                    error.message ||
                    "Unable to logout."
                );

            }

        }
    );


/* =========================================================
   START DASHBOARD
========================================================= */

loadDashboard();