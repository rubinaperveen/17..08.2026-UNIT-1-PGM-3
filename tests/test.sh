#!/bin/bash

MYSQL="mysql -h 127.0.0.1 -P 3306 -u root -proot --protocol=tcp -N -B"

PASS=0
FAIL=0

echo "=========================================="
echo " PROGRAM 3 - ALTER STUDENT TABLE"
echo "=========================================="

pass() {
    echo "PASS: $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
}

# Test 1
STUDENT=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student';
")

if [ "$STUDENT" = "1" ]; then
    pass "Student table exists"
else
    fail "Student table does not exist"
fi

# Test 2
EMAIL=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Email'
AND DATA_TYPE='varchar'
AND CHARACTER_MAXIMUM_LENGTH=30;
")

if [ "$EMAIL" = "1" ]; then
    pass "Email VARCHAR(30)"
else
    fail "Email VARCHAR(30) is incorrect"
fi

# Test 3
PHONE=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='PhoneNumber';
")

if [ "$PHONE" = "1" ]; then
    pass "PhoneNumber column exists"
else
    fail "PhoneNumber column is missing"
fi

# Test 4
PHONE_TYPE=$($MYSQL -e "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='PhoneNumber';
")

case "$PHONE_TYPE" in
    int|integer|bigint|smallint|mediumint|tinyint|decimal|numeric)
        pass "PhoneNumber is numeric"
        ;;
    *)
        fail "PhoneNumber is not numeric"
        ;;
esac

# Test 5
EMAIL_COUNT=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Email';
")

if [ "$EMAIL_COUNT" = "1" ]; then
    pass "Email exists exactly once"
else
    fail "Email column problem"
fi

# Test 6
PHONE_COUNT=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='PhoneNumber';
")

if [ "$PHONE_COUNT" = "1" ]; then
    pass "PhoneNumber exists exactly once"
else
    fail "PhoneNumber column problem"
fi

echo ""
echo "=========================================="
echo "PROGRAM 3 RESULT"
echo "=========================================="

echo "Passed: $PASS / 6"
echo "Failed: $FAIL / 6"

if [ "$FAIL" -eq 0 ]; then
    echo ""
    echo "ALL 6 TEST CASES PASSED"
    echo "PROGRAM 3 COMPLETED SUCCESSFULLY"
    exit 0
else
    echo ""
    echo "SOME TEST CASES FAILED"
    exit 1
fi
