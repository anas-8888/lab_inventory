'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { applyWasteMarkup } = require('../src/utils/costCalculations');

test('10% waste adds exactly 10% to the cost', () => {
    assert.equal(applyWasteMarkup(1, 10), 1.1);
});

test('zero waste keeps the original cost', () => {
    assert.equal(applyWasteMarkup(7.25, 0), 7.25);
});

test('the markup works for a per-kilogram cost', () => {
    const totalPrice = 1;
    const grossWeight = 100;
    const packagingWeight = 100;
    const adjustedPerKg = applyWasteMarkup(totalPrice / grossWeight, 10);

    assert.equal(Number((adjustedPerKg * packagingWeight).toFixed(2)), 1.1);
});

test('invalid numeric input produces a safe zero', () => {
    assert.equal(applyWasteMarkup('not-a-number', 10), 0);
    assert.equal(applyWasteMarkup(1, 'not-a-number'), 0);
});
