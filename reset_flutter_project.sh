#!/bin/bash
echo "Starting...."
echo "Clean your project"
flutter clean
echo "RUN: clean"
rm -Rf ios/Pods
echo "RUN: rm -Rf ios/Pods"
rm -Rf ios/.symlinks
echo "RUN: rm -Rf ios/.symlinks"
rm -Rf ios/Flutter/Flutter.framework
echo "RUN: rm -Rf ios/Flutter/Flutter.framework"
rm -Rf ios/Flutter/Flutter.podspec
echo "RUN: rm -Rf ios/Flutter/Flutter.podspec"
rm -Rf ios/Podfile.lock
echo "RUN: rm -Rf ios/Podfile.lock"
rm -Rf pubspec.lock
echo "RUN: rm -Rf pubspec.lock"
#rm -Rf ios/Podfile
#echo "RUN: rm -Rf ios/Podfile"
flutter pub get
echo "RUN: flutter pub get"
# shellcheck disable=SC2164
cd iOS
echo "RUN: cd iOS"

arch -x86_64 pod install --repo-update
echo "RUN: arch -x86_64 pod install --repo-update"

echo "That's it, enjoy ;)"