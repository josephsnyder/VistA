.. figure::
   http://code.osehra.org/content/named/SHA1/c0286b38-OSEHRA_LogoText.png
   :align: center
   :scale: 350 %


====================================================================================
  OSEHRA Code Submissions in Response to a VA Performance Work Statement (PWS)
====================================================================================

.. class:: center

  *Meeting the Requirements of Open Source*

1 Introduction
******************

The Open Source Electronic Health Record Agent (OSEHRA) is currently working
with the U.S. Department of Veterans Affairs (VA) and a growing open source
community to provide access to and support for the Veterans Health Information
Systems and Technology Architecture(VistA). This service is greatly enhanced by
the active participation of the VA, VA contractors, external EHR vendors, and
other interested community members. In recognition of this benefit, the VA has
recently published the "Veterans Open Source Performance Work Statement
Guidelines" to clarify the expectations for open source submission of code
developed using VA funds including guidelines for the construction of a
Performance Work Statement (PWS) involving development of new software to be
created for the VA and submitted to the open source community.

The purpose of this document is to clarify the steps necessary to submit open
source code to OSEHRA and to obtain OSEHRA Open Source Software Quality
Certification ("OSEHRA Certification"). These two milestones are required in
satisfaction of specific Performance Work Statement clauses in some VA
contracts. The explicit definitions of submission and certification in this
document are meant to avoid confusion and to help reduce uncertainty. Note that
this document is only concerned with OSEHRA requirements. The VA, as the
contracting entity, may have requirements in addition to the specifics outlined
below.

2 Submitting Code
********************

Code submissions to OSEHRA in satisfaction of PWS requirements are made via the
OSEHRA Technical Journal (OTJ). [#]_ The OTJ provides a facility for
encapsulating submissions that:

* allows for a thorough description of the submitted code including technical
  documentation, user manuals, and tests,
* allows community members to download, use, try, and maintain the submitted
  code prior to and independently of its eventual inclusion into the OSEHRA
  code base, and
* allows for persistence of the submission.

Full and updated web instructions for submitting to the OTJ can be found at
`OTJ Instructions`_, but for
convenience we will summarize the current state below. In addition,
webinar-style tutorials for a number of key processes, including OTJ
submission, are available on the OSEHRA site.

2.1 Submission Content
------------------------

The OTJ provides a mechanism for code intake that allows stand-alone
understanding of the purpose, usage, code structure, testing, and provenance
of submitted code. The submission does not need to be extensive, but should be
reflective of the size and complexity of the submission. With this in mind, an
OTJ submission must provide the following:

* A Technical Article that describes the functional goals of the system, the
  use of the system, and details that may help potential users or open source
  developers as they work with the code.
* The source code for the submission
* A set of automated tests that execute using the OSEHRA Code Testing
  framework [#]_
* A description of any additional functional tests that should be carried out
  to fully test the system

Other documents such as requirements definitions, user manuals, etc. may be
submitted as well, but these four components are key.

2.1.1 Technical Article
++++++++++++++++++++++++

The Technical Article is the first required component. A Technical Article is
expected to follow the style of a technical report, with particular focus on
providing guidance for the future use and maintenance of the new code
submission. It must explain why the submission is important or desirable, and
must adequately describe the submission such that it is usable, understandable,
and testable for a wide-ranging audience. For complicated or large submissions,
the Technical Article may comprise multiple individual documents such as a User
Manual, a Technical Manual, and/or a Testing Manual.

In addition, submissions in response to a VA contract may have other
documentation requirements such as a Business Requirements Document, a Software
Requirements Specification, a Software Test Plan, etc. During OSEHRA
Certification, *OSEHRA does not determine to what extent a contractor is
compliant with the VA contracted deliverables*, but any such deliverables that
are approved for distribution by the VA (including any VA required redaction)
can be made available to the open source community via OSEHRA as part of the
submission process. All such documents should be referenced from the Technical
Journal Article with a brief description.

2.1.2 Source Code
++++++++++++++++++

The second component is the source code. The source code should be complete,
free from licensing issues, and the submitter must be authorized to release it.
The source code will be evaluated as part of the OSEHRA Certification process,
and the submitted code will be subject to Standards and Conventions (SAC)
compliance checking as well as peer review.

2.1.3 Automated Tests and Associated Test Data
+++++++++++++++++++++++++++++++++++++++++++++++

There are several objectives to OSEHRA testing, including demonstration of code
correctness, evaluation of usage instructions, and generation of code
regressions that can be used to track behavior over time. Submissions must have
two different types of tests: regression and functional.

Regression tests capture specific and detailed program behavior. They show that
the code works as expected and provide a baseline against which the impact of
future modifications can be validated and monitored. Typically, these are
implemented as unit tests because these are most useful for baselining changes,
localizing problems areas, and determining pass/fail. Functional tests
demonstrate the use of the system in practice, and generally evaluate the code
from a higher-level perspective. Community members wishing to use submitted
code should be able to look at the functional testing and get a good idea of
what the code does, how they would use it, and how they could integrate it into
their code or workflow. Both sets of tests must be executable by the community
and will be evaluated during OSEHRA Certification. For more information, refer
to the table of certification levels and requirements in the "OSEHRA
Certification Standards" document. All submitted tests must also be capable of
being integrated into the OSEHRA test harness as described at:

`SetupTestingEnvironment`_

This ensures that the tests can be part of a continuous and automated
regression baseline. Use of this framework allows OSEHRA to standardize and
automate the test execution procedures and allows regression baselines to be
recorded and preserved in a testing dashboard. Developers are encouraged to
contact OSEHRA with any suggestions for inclusion of techniques or frameworks
that are not currently integrated into the OSEHRA test harness.

2.1.4 Submission Philosophy
++++++++++++++++++++++++++++

When writing the Technical Article and packaging the code for submission into
the OTJ, it is important that the submitter keep the purpose of the OTJ in
mind. If a community member with a minimal understanding of the application
area cannot download, install, test, and use the submission with little or no
assistance, then the submission is inadequate.

.. figure::
   http://code.osehra.org/content/named/SHA1/c080b430-OTJSubmitHighlighted.png
   :align: center
   :alt:  OSEHRA Tech Journal front page with Submit button highlighted

Figure 2-1: OSEHRA Technical Journal front page showing the Submit button

2.2 Submission Specifics
--------------------------

Submitting code to the OTJ is designed to be as straightforward as possible.
First, generate the Technical Article as a PDF, and then use an archival tool
(for example, zip or tar.gz) to generate the following additional artifacts:

* The source code to be submitted
* The source code for tests submitted in support of the code
* The data required for the tests
* Any additional supporting documents desired for submission (optional)

When combined with the Technical Article, this results in at least four files
that need to be prepared (more if multiple files are used for tests, documents,
etc.). Once they are ready, go to the OTJ and click on Submit as shown in
Figure 2-1 above. The submission process will walk through the required steps
of the submission including:

* Choosing a submission target

* Agreeing to the open source license

* Filling in the contact and general information of the submission

* Uploading the following:

  * Technical Article

    * The technical article should be licensed using "Creative Commons by
      Attribution 3.0 License"

  * Source Code

    * All source code should be licensed using "Apache License 2.0"

  * Test Code

    * All testing code should be licensed using "Apache License 2.0"

  * Data

    * All data should be licensed using `Creative Commons - Public Domain
      Dedication License`_

  * Supporting documents (Optional)

    * All documents should be licensed using `Creative Commons by
      Attribution 3.0 License`_

  * A developer-specific logo (Optional)

At the end of the process the article and code are uploaded to the OTJ and
become available for download, review, and comments.

3 Code Review and Open Source Software Quality
***************************************************

Certification
Once a complete code submission has been made, the OSEHRA certification process
can begin. The purpose of OSEHRA Certification is to "get eyes on the code",
baseline the code state, and validate that the submission meets the
requirements of good coding practices and open source compliance. Specific
information on certification levels and scoring criteria is available in the
"OSEHRA Certification Standards" document. Details on the process are available
in the "OSEHRA Certification Process" document.

The OTJ submission is reviewed in two phases. During the first phase, peer
review, any community member has the opportunity to review the submission and
to offer an opinion as to how well the code meets OSEHRA quality objectives.
Once a sufficient number of peer reviews have been contributed, peer review
will be closed and the community under the guidance of OSEHRA will perform a
final guided review of the system, culminating in a final certification
determination.

While the process is described sequentially, it is rare that a code submission
will make it through the entire process the first time. Feedback from reviewers
during the peer review and final review stages is expected to result in changes
to the submitted code. It is critical that developers remain engaged and
available during the review process to respond to feedback and address issues.
OSEHRA will work to facilitate the review and approval process, and will work
with the developers to rectify any issues discovered during OSEHRA
Certification. For more information about OSEHRA certification, refer to the
document "OSEHRA Certification Standards."

4 Conclusions and Recommendations
***********************************

Developing code for an open source release is an iterative effort.
Understanding the dynamics of open source communities is critical and needs to
be considered early in the development of the code. We therefore recommend that
developers engage the open source community as early as possible in the
development process. While incomplete OTJ submissions will not be certified,
the OTJ does allow for partial submissions and does support versioning.
OSEHRA Certification is not guaranteed. Providing partial deliveries to let the
community know what is under development is a good way to get preliminary
feedback and to mitigate the risk that a submission will not meet OSEHRA
Certification requirements. With this in mind, developers should consider the
following strategy:

1. Before starting, get the OSEHRA testing environment up and running.
2. Develop the code using a test driven process. As each module is designed,
   generate the unit, functional and regression tests that will be used to
   verify the code as correct and use them during development to verify and
   guide code generation.
3. Develop in the open to the degree possible. At a minimum, use the
   versioning capacity of the OTJ to announce and iteratively improve your
   code.
4. Submit early. OSEHRA Certification evaluation may require several
   iterations. If you can get a subset of the code certified prior to
   submission of the entirety of the code for certification, you can
   iteratively add to the certified core at lower risk.

.. [#] This presumes that new code or functionality is being developed under
   the PWS. For bug fixes, the Gerrit review process is used in place of the
   OTJ. See the OSEHRA Certification Standards document for additional details.
.. [#] See the OSEHRA Certification Standards document for a description of the
   available tools.
.. _`OTJ Instructions`: http://www.osehra.org/wiki/submitting-osehra-technical-journal
.. _`SetupTestingEnvironment`: https://github.com/OSEHRA/VistA/blob/master/Documentation/SetupTestingEnvironment.rst#set-up-the-testing-environment.
.. _`Creative Commons - Public Domain Dedication License`: http://creativecommons.org/publicdomain/zero/1.0/
.. _`Creative Commons by Attribution 3.0 License`: http://creativecommons.org/licenses/by/3.0/
