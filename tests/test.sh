#!/bin/bash

MYSQL="mysql -h 127.0.0.1 -P 3306 -u root -proot --protocol=tcp -N -B"

PASS=0
FAIL=0
TOTAL=6

pass() {
    echo "✅ PASS: $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "❌ FAIL: $1"
    FAIL=$((FAIL + 1))
}

echo "=========================================="
echo " PROGRAM 3 - ALTER STUDENT TABLE"
echo "=========================================="

# ------------------------------------------
# TEST 1 - CollegeDB exists
# ------------------------------------------

DB=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME='CollegeDB';
")

if [ "$DB" = "1" ]; then
    pass "CollegeDB database exists"
else
    fail "CollegeDB database does not exist"
fi


# ------------------------------------------
# TEST 2 - Student table exists
# ------------------------------------------

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


# ------------------------------------------
# TEST 3 - Email VARCHAR(30)
# ------------------------------------------

EMAIL_TYPE=$($MYSQL -e "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Email';
")

EMAIL_LENGTH=$($MYSQL -e "
SELECT CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Email';
")

if [ "$EMAIL_TYPE" = "varchar" ] && [ "$EMAIL_LENGTH" = "30" ]; then
    pass "Email VARCHAR(30)"
else
    fail "Email is not VARCHAR(30)"
fi


# ------------------------------------------
# TEST 4 - PhoneNumber numeric
# ------------------------------------------

PHONE_TYPE=$($MYSQL -e "
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='PhoneNumber';
")

if [[ "$PHONE_TYPE" == "tinyint" ||
      "$PHONE_TYPE" == "smallint" ||
      "$PHONE_TYPE" == "mediumint" ||
      "$PHONE_TYPE" == "int" ||
      "$PHONE_TYPE" == "integer" ||
      "$PHONE_TYPE" == "bigint" ||
      "$PHONE_TYPE" == "decimal" ||
      "$PHONE_TYPE" == "numeric" ]]; then

    pass "PhoneNumber is numeric"

else

    fail "PhoneNumber is not numeric"

fi


# ------------------------------------------
# TEST 5 - Email exists once
# ------------------------------------------

EMAIL_COUNT=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='Email';
")

if [ "$EMAIL_COUNT" = "1" ]; then
    pass "Email column added correctly"
else
    fail "Email column missing or duplicated"
fi


# ------------------------------------------
# TEST 6 - PhoneNumber exists once
# ------------------------------------------

PHONE_COUNT=$($MYSQL -e "
SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='CollegeDB'
AND TABLE_NAME='Student'
AND COLUMN_NAME='PhoneNumber';
")

if [ "$PHONE_COUNT" = "1" ]; then
    pass "PhoneNumber column added correctly"
else
    fail "PhoneNumber column missing or duplicated"
fi


# ------------------------------------------
# FINAL RESULT
# ------------------------------------------

echo ""
echo "=========================================="
echo " PROGRAM 3 RESULT"
echo "=========================================="

echo "Passed : $PASS / $TOTAL"
echo "Failed : $FAIL / $TOTAL"

echo "=========================================="

if [ "$FAIL" -eq 0 ]; then

    echo "🎉 PROGRAM 3 - ALL TEST CASES PASSED"
    exit 0

else

    echo "❌ PROGRAM 3 - SOME TEST CASES FAILED"
    exit 1

fi
