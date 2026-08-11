// ============================================================
// AUTHENTICATION MIDDLEWARE
// ============================================================

const requireAuth = (req, res, next) => {

    if (!req.session || !req.session.user) {
        return res.status(401).json({
            success: false,
            message: 'Authentication required.'
        });
    }

    next();
};


// ============================================================
// ROLE AUTHORIZATION MIDDLEWARE
// ============================================================

const requireRole = (...allowedRoles) => {

    return (req, res, next) => {

        if (!req.session || !req.session.user) {
            return res.status(401).json({
                success: false,
                message: 'Authentication required.'
            });
        }

        const userRole = req.session.user.role;

        if (!allowedRoles.includes(userRole)) {
            return res.status(403).json({
                success: false,
                message: 'You do not have permission to perform this action.'
            });
        }

        next();
    };
};


module.exports = {
    requireAuth,
    requireRole
};