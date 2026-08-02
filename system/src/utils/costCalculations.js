'use strict';

/**
 * Applies the entered waste percentage as a direct cost markup.
 * Example: 1.00 with 10% waste becomes 1.10.
 */
const applyWasteMarkup = (costBeforeWaste, wastePercentage) => {
    const cost = Number(costBeforeWaste);
    const percentage = Number(wastePercentage);

    if (!Number.isFinite(cost) || !Number.isFinite(percentage)) {
        return 0;
    }

    return cost * (1 + (percentage / 100));
};

module.exports = { applyWasteMarkup };
