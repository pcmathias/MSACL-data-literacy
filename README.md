# MSACL-data-literacy
Course webpage for MSACL Data Science 100 short course

## Before You Arrive: Installing R, RStudio, and Claude

Please complete these steps **before** the session — they take about 15–20 minutes and we won't have time to troubleshoot installations during class. If anything fails, see the fallback option at the bottom.

---

### 1. Install R

R is the underlying programming language. Install it first — RStudio needs it to work.

**Windows:**
1. Go to [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)
2. Click the link at the top (e.g. "Download R-4.x.x for Windows")
3. Run the downloaded installer and accept all the defaults

**Mac:**
1. Go to [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
2. Download the `.pkg` file that matches your Mac (if you're not sure whether you have an Apple Silicon or Intel Mac, choose the "arm64" build for newer Macs from 2020+, or the other link if your Mac is older)
3. Run the installer and accept all the defaults

---

### 2. Install RStudio

RStudio is the application you'll actually work in — it provides a friendlier interface on top of R.

1. Go to [https://docs.posit.co/ide/user/#rstudio-ide-oss-downloads](https://docs.posit.co/ide/user/#rstudio-ide-oss-downloads)
2. Download the installer for your operating system (open-source edition)
3. Run the installer and accept all the defaults

**Verify it worked:** Open RStudio. You should see several panes (windows) inside the application. In the pane labeled **Console**, type:

```r
1 + 1
```

and press Enter. If you see `[1] 2`, you're set up correctly.

---

### 3. Install the tidyverse package

This course uses a collection of R packages called the tidyverse. Installing it now avoids a slow download during class.

1. In RStudio, click into the **Console** pane
2. Type the following and press Enter:

```r
install.packages("tidyverse")
```

3. This will take a few minutes and print a lot of text — that's normal. Wait for it to finish and return you to the `>` prompt with no red error text at the end (warnings in red are usually fine; an actual error means something went wrong)

---

### 4. Download the course materials

1. Go to [github.com/pcmathias/MSACL-data-literacy](https://github.com/pcmathias/MSACL-data-literacy) (or scan the QR code provided at the session)
2. Click the green **Code** button, then **Download ZIP**
3. Unzip the folder somewhere you'll remember (e.g. your Desktop or Documents folder) — do **not** leave it inside your Downloads folder or inside another zip
4. Inside the unzipped folder, double-click the `.Rproj` file to open the course project in RStudio

---

### 5. Set up a free Claude account

We'll use Claude (Anthropic's AI assistant) during a few parts of the course. A free account is all you need.

1. Go to [https://claude.ai](https://claude.ai)
2. Click **Sign up**
3. Enter your email address (or continue with Google) and follow the verification steps
4. Once logged in, you'll land on a chat screen — that's it, no further setup needed

You do not need a paid plan for anything in this course.

---

### 6. Install the Claude desktop app (recommended)

The desktop app is the same Claude account you just created, in a dedicated application instead of a browser tab — it's a bit more convenient to switch to during the course than a browser tab, but it's optional.

**Windows and Mac:**
1. Go to [https://claude.ai/download](https://claude.ai/download)
2. Download the installer for your operating system
3. Run the installer and accept all the defaults
4. Open the app and sign in with the same account you created in Step 5

If you'd rather not install another application, using Claude at [https://claude.ai](https://claude.ai) in your browser works identically for everything in this course.

---

### If Installation Fails: Posit Cloud (Backup Plan)

If R or RStudio won't install on your machine (locked-down work laptop, permissions issues, etc.), you can run everything in a browser instead, with no installation:

1. Go to [https://posit.cloud](https://posit.cloud)
2. Click **Sign Up** and create a free account
3. Once logged in, you'll have access to RStudio running in the cloud — the course materials can be uploaded there on the day of the session

Please still try the normal installation first — Posit Cloud is slower and has usage limits on the free tier, so it's a fallback, not the primary plan.


