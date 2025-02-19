<h2>Foydali fayllar</h2>
<ul>
    <li><strong>Nashville.xlsx</strong> - Asl ma'lumotlar fayli.</li>
    <li><strong>Nashville_Cleaning_Pandas.ipynb</strong> - Jupyter Notebook fayli, bu yerda Pandas yordamida ma'lumotlarni tozalash jarayoni amalga oshiriladi.</li>
    <li><strong>Nashville_Cleaning_query.sql</strong> - SQL skript fayli, bu SQL yordamida ma'lumotlarni tozalash amallarini o'z ichiga oladi.</li>
    <li><strong>Nashville_new.xlsx</strong> - Tozalangan ma'lumotlar fayli.</li>
</ul>

<h2>GitHub-dan yuklab olish</h2>
<pre>
    git clone &lt;repository-url&gt;
    cd &lt;repository-folder&gt;
    git pull origin main
</pre>

<h2>Loyihani ishlatish</h2>

<h3>Pandas yordamida tozalash</h3>
<ol>
    <li><code>Nashville_Cleaning_Pandas.ipynb</code> faylini Jupyter Notebook yoki VS Code'da oching.</li>
    <li>Har bir hujayrani ketma-ket bajarib, ma'lumotlarni tozalang.</li>
    <li>Natijani <code>Nashville_new.xlsx</code> fayliga saqlang.</li>
</ol>

<h3>SQL yordamida tozalash</h3>
<ol>
    <li><code>Nashville.xlsx</code> faylini SQL ma'lumotlar bazasiga yuklang.</li>
    <li><code>Nashville_Cleaning_query.sql</code> faylida berilgan SQL buyruqlarini ishga tushuring.</li>
    <li>Natijani CSV yoki Excel formatida saqlang.</li>
</ol>

<h2>Muhim eslatmalar</h2>
<ul>
    <li>Pandas kodini ishlatish uchun quyidagi kutubxonani o'rnatilgan bo'lishi kerak:
        <pre>
            pip install pandas
        </pre>
    </li>
    <li>SQL kodini bajarish uchun SQLite yoki PostgreSQL kabi SQL tizimlaridan foydalanishingiz mumkin.</li>
</ul>

<h2>Mualliflik huquqi</h2>
<p>Ushbu loyiha ochiq kodli va foydalanish bepul. Agar loyihani kengaytirish yoki yangilash niyatingiz bo'lsa, PR (Pull Request) orqali o'zgarishlaringizni taklif qilishingiz mumkin.</p>
