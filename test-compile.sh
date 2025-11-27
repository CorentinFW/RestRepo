#!/bin/bash

echo "🔧 Compilation du module Hotellerie..."
echo ""

cd /home/corentinfay/Bureau/RestRepo/Hotellerie

# Compilation
mvn clean install -DskipTests

STATUS=$?

echo ""
if [ $STATUS -eq 0 ]; then
    echo "✅ BUILD SUCCESS"
    echo ""
    echo "Les fichiers .properties ont été corrigés."
    echo "Vous pouvez maintenant lancer : ./fix-h2-databases.sh"
else
    echo "❌ BUILD FAILURE"
    echo ""
    echo "L'erreur persiste. Vérifiez les logs ci-dessus."
fi

exit $STATUS

