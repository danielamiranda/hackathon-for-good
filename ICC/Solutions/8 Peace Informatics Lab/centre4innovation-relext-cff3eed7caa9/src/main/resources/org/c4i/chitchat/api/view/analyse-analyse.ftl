<#import "utils.ftl" as u>

<#macro pageTitle>
Relext - Analyse
</#macro>

<#macro pageContent>

<style>
    #map {
        height: 400px;
        z-index: 5;
    }

    .m-portlet.m-portlet--fullscreen #map {
        z-index: 7;
    }

    .CodeMirror {
        border: 1px solid #eee;
    }

    .m-form.m-form--group-seperator-dashed .m-form__group, .m-form.m-form--group-seperator .m-form__group  {
        padding-top: 10px;
        padding-bottom: 10px;
    }

    .m-form .m-form__actions {
        padding: 10px 30px;
    }

    .plotly .modebar {
        z-index: 1 !important;
    }

</style>

<div class="m-subheader ">
    <div class="d-flex align-items-center">
        <div class="mr-auto">
            <h3 class="m-subheader__title m-subheader__title--separator">
                Analyse
            </h3>
            <ul class="m-subheader__breadcrumbs m-nav m-nav--inline">
                <li class="m-nav__item m-nav__item--home">
                    <a href="/api/v1/ui/dashboard" class="m-nav__link m-nav__link--icon">
                        <i class="m-nav__link-icon la la-home"></i>
                    </a>
                </li>
                <li class="m-nav__separator">-</li>
                <li class="m-nav__item">
                    <a href="" class="m-nav__link">
											<span class="m-nav__link-text">
												Analyse
											</span>
                    </a>
                </li>
                <li class="m-nav__separator">-</li>
                <li class="m-nav__item">
                    <a href="" class="m-nav__link">
											<span class="m-nav__link-text">
												Analyse
											</span>
                    </a>
                </li>
            </ul>
        </div>
    <#--<div>
        <div class="form-inline m-form__group">

            <div class="input-group m-input-group  m-input-group--pill mr-2" style="box-shadow: 0 3px 20px 0 rgba(113,106,202,.17)!important">
                <select id="channelSelect" class="form-control m-input custom-select">
                    <option value="" selected>- all -</option>
                    <option value="fb">Facebook</option>
                    <option value="chitchat">Relext</option>
                    <option value="devbot">Devbot</option>
                    <option value="sample">Sample data</option>
                </select>
                <div class="input-group-append">
                    <label class="input-group-text m-input--pill" for="channelSelect" style="border-top-right-radius: 1.3rem;border-bottom-right-radius: 1.3rem;background: white;"><i class="la la-plug"></i></label>
                </div>
            </div>

            <span id="m_dashboard_daterangepicker"></span>
        </div>

    </div>-->
    </div>
</div>
<div class="m-content">
    <div class="row">
        <div class="col-md-12">
            <div class="m-portlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
												<span class="m-portlet__head-icon">
													<i class="la la-filter"></i>
												</span>
                            <h3 class="m-portlet__head-text">
                                Filter
                            </h3>
                        </div>
                    </div>
                </div>
                <!--begin::Form-->
                <form class="m-form m-form--fit m-form--label-align-right m-form--group-seperator-dashed">
                    <div class="m-portlet__body">
                        <div class="form-group m-form__group row">
                            <label class="col-lg-2 col-form-label">
                                Period <i class="text-muted la la-info-circle" title="The period in which conversations should fall"></i>
                            </label>
                            <div class="col-lg-4">
                                <div class="input-group" id="m_daterangepicker">
                                    <input type="text" class="form-control m-input" readonly="" placeholder="Select date range">
                                    <div class="input-group-append">
													<span class="input-group-text">
														<i class="la la-calendar-check-o"></i>
													</span>
                                    </div>
                                </div>
                            </div>

                            <label class="col-lg-2 col-form-label">
                                Channel <i class="text-muted la la-info-circle" title="The instant messaging data source"></i>
                            </label>
                            <div class="col-lg-4">
                                <select id="channelSelect" class="form-control m-input custom-select">
                                    <option value="" selected>- all -</option>
                                    <option value="fb">Facebook</option>
                                    <option value="chitchat">Relext</option>
                                    <option value="devbot">Devbot</option>
                                    <option value="sample">Sample data</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group m-form__group row">
                            <label class="col-lg-2 col-form-label">
                                Labels <i class="text-muted la la-info-circle" title="Drill down on (the combination of) labels"></i>
                            </label>
                            <div class="col-lg-6 col-sm-12" id="labelSelectContainer">
                                <select class="form-control m-select2" id="labelSelect" name="labelSelect" multiple="multiple"></select>
                            </div>
                        </div>
                        <div class="m-form__group m-form__group--last form-group row">
                            <label class="col-lg-2 col-form-label">
                                Custom script <i class="text-muted la la-info-circle" title="Use custom labels, instead of previously matched labels"></i>
                            </label>
                            <div class="col-lg-10 col-sm-12">

                                <div class="row" id="scriptPanel" style="overflow:hidden; height: 40px;">
                                    <span class="col-12 m-form__help" style="height: 40px;">
                                        <label class="m-checkbox m-checkbox--solid m-checkbox--brand">
											<input type="checkbox" id="toggleScriptBtn"> Define custom labels
											<span></span>
                                        </label>
                                    </span>
                                    <div class="col-11" style="height: 400px; padding-bottom: 20px;">
                                        <textarea id="scriptEditor" style="display: none;"></textarea>

                                    </div>
                                    <div class="col-1">
                                        <ul class="m-portlet__nav" style="padding: 0;">
                                            <li class="m-portlet__nav-item m-dropdown m-dropdown--inline m-dropdown--arrow m-dropdown--align-right m-dropdown--align-push" m-dropdown-toggle="hover" aria-expanded="true">
                                                <a href="#" class="m-portlet__nav-link btn btn-secondary  m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill   m-dropdown__toggle">
                                                    <i class="la la-ellipsis-v"></i>
                                                </a>
                                                <div class="m-dropdown__wrapper" style="z-index: 101;">
                                                    <span class="m-dropdown__arrow m-dropdown__arrow--right m-dropdown__arrow--adjust" style="left: auto; right: 21.5px;"></span>
                                                    <div class="m-dropdown__inner">
                                                        <div class="m-dropdown__body">
                                                            <div class="m-dropdown__content">

                                                                <ul class="m-nav">
                                                                    <li class="m-nav__section m-nav__section--first">
                                                                        <span class="m-nav__section-text">Actions</span>
                                                                    </li>

                                                                    <li class="m-nav__item">
                                                                        <a id="openScriptBtn" class="m-nav__link" data-toggle="modal" data-target="#loadExampleModal">
                                                                            <i class="m-nav__link-icon la la-star-o"></i>
                                                                            <span class="m-nav__link-text">Open example</span>
                                                                        </a>
                                                                    </li>

                                                                    <li class="m-nav__separator m-nav__separator--fit">
                                                                    <li class="m-nav__item">
                                                                        <a id="newScriptBtn" class="m-nav__link">
                                                                            <i class="m-nav__link-icon la la-file"></i>
                                                                            <span class="m-nav__link-text">New script</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="m-nav__item">
                                                                        <a id="openScriptBtn" class="m-nav__link" data-toggle="modal" data-target="#openCssModal">
                                                                            <i class="m-nav__link-icon la la-folder-open-o"></i>
                                                                            <span class="m-nav__link-text">Open script</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="m-nav__item">
                                                                        <a id="openVersionBtn" class="m-nav__link" data-toggle="modal" data-target="#openVersionModal">
                                                                            <i class="m-nav__link-icon la la-history"></i>
                                                                            <span class="m-nav__link-text">Open previous version</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="m-nav__item">
                                                                        <a id="saveScriptBtn" class="m-nav__link" data-toggle="modal" data-target="#saveCssModal">
                                                                            <i class="m-nav__link-icon la la-floppy-o"></i>
                                                                            <span class="m-nav__link-text">Save script</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="m-nav__item">
                                                                        <a id="downloadScriptBtn" class="m-nav__link">
                                                                            <i class="m-nav__link-icon la la-download"></i>
                                                                            <span class="m-nav__link-text">Download script</span>
                                                                        </a>
                                                                    </li>
                                                                    <li class="m-nav__separator m-nav__separator--fit">
                                                                    <li class="m-nav__item">
                                                                        <a id="normalizeScriptBtn" class="m-nav__link">
                                                                            <i class="m-nav__link-icon la la-magic"></i>
                                                                            <span class="m-nav__link-text">Normalize script</span>
                                                                        </a>
                                                                    </li>

                                                                    <li class="m-nav__separator m-nav__separator--fit">
                                                                    </li>
                                                                    <li class="m-nav__item">
                                                                        <a href="#" class="btn btn-outline-danger m-btn m-btn--pill m-btn--wide btn-sm">Cancel</a>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="m-portlet__foot m-portlet__no-border m-portlet__foot--fit">
                        <div class="m-form__actions m-form__actions--solid">
                            <div class="row">
                                <div class="col-lg-2"></div>
                                <div class="col-lg-6">
                                    <a id="runBtn" class="btn btn-brand" style="color: white">
                                        Update
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
                <!--end::Form-->
            </div>
            <!--end::Portlet-->
        </div>
    </div>

    <div class="row" style="margin-bottom: -25px;">
        <div class="col-md-12">

            <div class="m-portlet" id="legendPortlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
												<span class="m-portlet__head-icon">
													<i class="la la-tags"></i>
												</span>
                            <h3 class="m-portlet__head-text">
                                All labels
                            </h3>
                        </div>
                    </div>

                </div>
                <div class="m-portlet__body">
                    <div class="row">
                        <div class="col-lg-3 col-sm-12">Legend</div>
                        <div id="labels">
                            <button type="button" class="btn m-btn--pill btn-outline-metal disabled" disabled="disabled">Wait for results...</button>
                        </div>
                    </div>

                </div>
            </div>

        </div>
    </div>

    <div class="row" style="margin-bottom: -25px;">
        <div class="col-md-12">
            <div class="m-portlet"  m-portlet="true" id="timelinePortlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
                            <span class="m-portlet__head-icon"><i class="la la-line-chart"></i></span>
                            <h3 class="m-portlet__head-text">Label timeline</h3>
                        </div>

                    </div>
                    <div class="m-portlet__head-tools">
                        <ul class="m-portlet__nav">
                            <li class="m-portlet__nav-item">
                                <a m-portlet-tool="fullscreen"
                                   class="m-portlet__nav-link btn btn-secondary m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill">
                                    <i class="la la-expand"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="m-portlet__body">
                    <div id="timeline"></div>
                </div>
            </div>
        </div>
    </div>
    <div class="row" style="margin-bottom: -25px;">
        <div class="col-md-12 col-lg-6" style="padding-right: 2px;">
            <div class="m-portlet"  m-portlet="true" id="labelHistogramPortlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
                            <span class="m-portlet__head-icon"><i class="la la-bar-chart"></i></span>
                            <h3 class="m-portlet__head-text">Label frequencies</h3>
                        </div>
                    </div>
                    <div class="m-portlet__head-tools">
                        <ul class="m-portlet__nav">
                            <li class="m-portlet__nav-item">
                                <a m-portlet-tool="fullscreen"
                                   class="m-portlet__nav-link btn btn-secondary m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill">
                                    <i class="la la-expand"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="m-portlet__body">
                    <div  id="labelHistogram" style="height: 400px; width: 100%"></div>
                </div>
            </div>
        </div>
        <div class="col-md-12 col-lg-6" style="padding-left: 2px;">
            <div class="m-portlet" m-portlet="true" id="valueHistogramPortlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
                            <span class="m-portlet__head-icon"><i class="la la-bar-chart"></i></span>
                            <h3 class="m-portlet__head-text">Word frequencies</h3>
                        </div>
                    </div>
                    <div class="m-portlet__head-tools">
                        <ul class="m-portlet__nav">
                            <li class="m-portlet__nav-item">
                                <a m-portlet-tool="fullscreen"
                                   class="m-portlet__nav-link btn btn-secondary m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill">
                                    <i class="la la-expand"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="m-portlet__body">
                    <div id="valueHistogram" style="height: 400px;"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="m-portlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
												<span class="m-portlet__head-icon">
													<i class="la la-globe"></i>
												</span>
                            <h3 class="m-portlet__head-text">
                                Location
                            </h3>
                        </div>
                    </div>
                    <div class="m-portlet__head-tools">
                        <ul class="m-portlet__nav">
                            <li class="m-portlet__nav-item">
                                <a m-portlet-tool="fullscreen"
                                   class="m-portlet__nav-link btn btn-secondary m-btn m-btn--hover-brand m-btn--icon m-btn--icon-only m-btn--pill">
                                    <i class="la la-expand"></i>
                                </a>
                            </li>
                        </ul>
                    </div>

                </div>
                <div class="m-portlet__body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div id="noLocationMsg">No location information available...</div>
                            <div id="map"></div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="m-portlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
                            <span class="m-portlet__head-icon"><i class="la la-th-list"></i></span>
                            <h3 class="m-portlet__head-text"> Extract information </h3>
                        </div>
                    </div>

                </div>
                <div class="m-portlet__body">

                    <div class="form-group m-form__group row">
                        <label class="col-lg-2 col-form-label">
                            Columns <i class="text-muted la la-info-circle" title="Select labels that will become the columns"></i>
                        </label>
                        <div class="col-lg-6 col-sm-12" id="colSelectContainer">
                            <select class="form-control m-select2" id="colSelect" name="colSelect" multiple="multiple"></select>
                        </div>
                        <span class="btn btn-primary" id="exportDataBtn">Export</span>

                    </div>


                    <div class="row" id="exportDataRow" style="display: none;">
                        <div class="col-md-12">
                            <div class="pull-right form-control mb-2 mr-sm-2 m-input-icon m-input-icon--left" style="width: 200px">
                                <input type="text" class="form-control m-input" placeholder="Search..." id="searchInput">
                                <span class="m-input-icon__icon m-input-icon__icon--left">
                                    <span id="searchCount" class="text-success" style="width: 35px;margin-right: -30px;font-size: 9px;height: 10px;margin-bottom: -13px;margin-top: 3px;text-align: right;"></span>
                                    <span><i class="la la-search"></i></span>
                                </span>
                            </div>
                        </div>
                        <div style="height: 70vh; overflow: hidden; width: 100%">
                            <div id="handsontable"></div>

                        </div>
                        <span class="btn btn-success right" id="downloadSheet">Save as CSV</span>
                    </div>


                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="m-portlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
												<span class="m-portlet__head-icon">
													<i class="la la-database"></i>
												</span>
                            <h3 class="m-portlet__head-text">
                                Conversations
                            </h3>
                        </div>
                    </div>

                </div>
                <div class="m-portlet__body">
                    <div class="row">
                        <div class="col-12">
                            <form class="form-inline">
                                <div class="form-control mb-2 mr-sm-2 m-input-icon m-input-icon--left">
                                    <input type="text" class="form-control m-input" placeholder="Search..." id="convSearchInput">
                                    <span class="m-input-icon__icon m-input-icon__icon--left">
                                        <span><i class="la la-search"></i></span>
                                    </span>
                                </div>

                            <#--<div class="input-group mb-2 mr-sm-2  m-input-group">
                                <select id="channelSelect" class="form-control m-input custom-select">
                                    <option value="" selected>- all -</option>
                                    <option value="fb">Facebook</option>
                                    <option value="devbot">Devbot</option>
                                </select>
                                <div class="input-group-append">
                                    <label class="input-group-text" for="channelSelect"><i class="la la-plug"></i></label>
                                </div>
                            </div>

                            <div class="input-group mb-2 mr-sm-2  m-input-group" id="m_daterangepicker">
                                <input type="text" class="form-control" readonly="" placeholder="Select date range">
                                <div class="input-group-append">
                                  <span class="input-group-text">
                                    <i class="la la-calendar-check-o"></i>
                                  </span>
                                </div>
                            </div>-->
                            </form>
                        </div>


                    </div>
                    <div class="row">
                        <div class="col-12" id="convDataTableParent">
                            <div id="convDataTable"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-md-12">
            <div class="m-portlet" id="msgPortlet">
                <div class="m-portlet__head">
                    <div class="m-portlet__head-caption">
                        <div class="m-portlet__head-title">
												<span class="m-portlet__head-icon">
													<i class="la la-comments"></i>
												</span>
                            <h3 class="m-portlet__head-text">
                                Messages
                            </h3>
                        </div>
                    </div>

                </div>
                <div class="m-portlet__body">
                    <b>Highlight matches</b>
                    <div class="row">
                        <div class="col-12">
                            <div style="background-color: #faf9fc; padding: 10px; margin-bottom: 20px;" id="msgHighlight"></div>
                        </div>
                    </div>

                    <b>Message table</b>
                    <div class="row">
                        <div class="col-12">
                            <form class="form-inline">
                                <div class="form-control mb-2 mr-sm-2 m-input-icon m-input-icon--left">
                                    <input type="text" class="form-control m-input" placeholder="Search..." id="msgSearchInput">
                                    <span class="m-input-icon__icon m-input-icon__icon--left">
                                    <span><i class="la la-search"></i></span>
                                </span>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div id="msgDataTable"></div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>


<#-- Example modal -->
<div class="modal fade" id="loadExampleModal" tabindex="-1" role="dialog" aria-labelledby="loadExampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="loadExampleModalLabel">Open example script</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="loadExampleSelect">Select an example script</label>
                        <select class="form-control" id="loadExampleSelect">

                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button id="loadExampleBtn" type="button" class="btn btn-brand">Open</button>
            </div>
        </div>
    </div>
</div>
</#macro>

<#macro pageScript>
<link rel="stylesheet" type="text/css" href="/asset5/vendors/custom/handsontable/dist/handsontable.full.min.css">
<script src="/asset5/vendors/custom/handsontable/dist/handsontable.full.min.js"></script>
<script>
    $(document).ready(function () {
        $.hx.setCurrentPage('#menu-item-analyse-analyse')

        $('#convSearchInput').val($.hx.getUrlParam('keyword'))

        // Custom analyis script toggle
        let showScript = false;
        $('#toggleScriptBtn').change(() => {
            showScript = $('#toggleScriptBtn')[0].checked
            if(showScript) {
                $('#scriptPanel').css({height: '420px', overflow: 'visible'});
            } else {
                $('#scriptPanel').css({height: '40px', overflow: 'hidden'});
                updateLabelFilter();
            }
        })

        function updateLabelFilter() {
            showScript = $('#toggleScriptBtn')[0].checked
            if(!showScript){
                const channel = $.hx.get('channel', '')
                $.get('/api/v1/db/labels/' + encodeURIComponent(channel), function (labels) {
                    const labelSelect = $("#labelSelect");
                    $('option', labelSelect).remove();
                    for (const label of labels.sort()) {
                        labelSelect.append($("<option />").val(label).text(label))
                    }
                    const colSelect = $("#colSelect");
                    $('option', colSelect).remove();
                    for (const label of labels.sort()) {
                        colSelect.append($("<option />").val(label).text(label))
                    }
                })
            } else {
                const labelSelect = $("#labelSelect");
                $('option', labelSelect).remove();

                for (const label of Object.keys(all.labelHistogram).sort()) {
                    labelSelect.append($("<option />").val(label).text(label))
                }

                const colSelect = $("#colSelect");
                $('option', colSelect).remove();

                for (const label of Object.keys(all.labelHistogram).sort()) {
                    colSelect.append($("<option />").val(label).text(label))
                }
            }
        }

        updateLabelFilter()

        // Date range selector
        let fromDate = $.hx.get('startDate', moment().subtract(6, 'days'));
        let toDate = $.hx.get('endDate', moment());
        let dateRangeUpdate = function(start, end, label) {
            let title = '';
            let range = '';

            if ((end - start) < 100 || label === 'Today') {
                title = 'Today:';
                range = start.format('MMM D');
            } else if (label === 'Yesterday') {
                title = 'Yesterday:';
                range = start.format('MMM D');
            } else {
                let now = moment();
                if (start.year() !== end.year()) {
                    range = start.format('MMM D YYYY') + ' - ' + end.format('MMM D YYYY');
                } else {
                    if (now.year() === start.year()) {
                        range = start.format('MMM D') + ' - ' + end.format('MMM D');
                    } else {
                        range = start.format('MMM D') + ' - ' + end.format('MMM D YYYY');
                    }
                }
            }

            $.hx.set('startDate', start);
            $.hx.set('endDate', end);
            $('#m_daterangepicker .form-control').val( start.format('YYYY-MM-DD') + ' / ' + end.format('YYYY-MM-DD'));
            rerunHint()
        };

        $('#m_daterangepicker').daterangepicker({
            buttonClasses: 'm-btn btn',
            applyClass: 'btn-primary',
            cancelClass: 'btn-secondary',
            startDate: fromDate,
            endDate: toDate,
            ranges: {
                'Today': [moment(), moment()],
                'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                'This Month': [moment().startOf('month'), moment().endOf('month')],
                'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
            }
        }, dateRangeUpdate)

        dateRangeUpdate(fromDate, toDate, '');

        // Trigger window resize events after fullscreen portlet events, so widget may update layout
        $(".m-portlet").each(function () {
            let portlet = new mPortlet(this)
            portlet.on('afterFullscreenOn', function(portlet) {
                window.dispatchEvent(new Event('resize'));
            });

            portlet.on('afterFullscreenOff', function(portlet) {
                window.dispatchEvent(new Event('resize'));
            });
        })

        // Channel select
        $('#channelSelect')
                .val($.hx.get('channel', ''))
                .change(function(){
                    let selectedVal = $(this).find(":selected").val();
                    $.hx.set('channel', selectedVal)
                    updateLabelFilter()
                    rerunHint()
                })


        // multi label select
        $('#labelSelect').select2({
            placeholder: "Select matched labels for the given Channel",
        });
        $('#labelSelect').on('change', rerunHint)

        $('#colSelect').select2({
            placeholder: "Select columns",
        });


        // hint to click run
        function rerunHint() {
            $('#runBtn').css('animation', 'flash 1.5s')
            setTimeout(() => $('#runBtn').css('animation', ''), 1500)
        }

        function setScriptName(name) {
            $('#scriptName').val(name)
            $.hx.set('scriptName', name);
        }

        const scriptEditor = new CcsEditor($('#scriptEditor')[0], 'demo.ccs')

        const examples = [
            {
                title: '1. Simple',
                description: 'Look for simple occurrences in the sentences.',
                rules:
                        `# Find fruit occurrences
@fruit <- apple OR orange`,
                text:
                        `The phrase apple of my eye refers to something or someone that one cherishes above all others.
Apples is a also a type of fruit though. Oranges are too, by the way.`,

            },

            {
                title: '2. Logical expressions',
                description: 'Refine the rule with logical operators and sequence matching.',
                rules:
                        `# Find actual fruit occurrences
@fruit1 <- (apple AND  NOT of_my_eye) OR orange

# You can also write this, if you prefer operators
@fruit2 <- (apple &  -of_my_eye) | orange
`,
                text:
                        `The phrase apple of my eye refers to something or someone that one cherishes above all others.
Apples is a also a type of fruit though. Oranges are too, by the way.`,
            },
            {
                title: '3. Exact matching',
                description: 'Use double quoted words for exact matches.',
                rules:
                        `# Only match all-caps instances
@disease <- "AIDS"`,
                text:
                        `She aids people with AIDS.`,
            },
            {
                title: '4. Sequence with wildcards',
                description: 'Use wildcards for matches where word order matters, but leaves room for additional words.',
                rules:
                        `# exacly one words between 'little' and 'girl'.
@chica <- little_?_girl

# one or more words between 'in' and 'village'
@village_based <- in_+_village

# zero or more words in between...
@grandma <- my_*_grandmother
`,
                text:
                        `Once upon a time there lived in a certain village a little country girl,
the prettiest creature that ever was seen. Her mother was very fond of
her, and her grandmother loved her still more. This good woman made
for her a little red riding-hood, which became the girl so well that
everybody called her Little Red Riding-hood.
One day her mother, having made some custards, said to her, "Go,
my dear, and see how your grandmother does, for I hear she has been
very ill; carry her a custard and this little pot of butter."
Little Red Riding-hood set out immediately to go to her
grandmother's, who lived in another village.
As she was going through the wood, she met Gaffer Wolf, who had a
very great mind to eat her up; but he dared not, because of some fagotmakers
hard by in the forest. He asked her whither she was going. The
poor child, who did not know that it was dangerous to stay and hear a
wolf talk, said to him, "I am going to see my grandmother, and carry her a
custard and a little pot of butter from my mamma."
"Does she live far off?" said the Wolf...`,
            },
            {
                title: '5. Match scope',
                description: 'Normally, rules are applied per sentence, but you can also match against the entire text.',
                rules:
                        `@fruit_fail <- apple & orange
@fruit_success {within: all} <- apple & orange`,
                text:
                        `This sentence is about apples.
And this one about oranges.`,
            },
            {
                title: '6. References',
                description: 'Reuse labels you defined in other rules for hierarchy.',
                rules:
                        `@mother <- mamma OR mother OR grandmother

# reuse @mother definition...
@woman <- @mother OR girl OR woman
`,
                text:
                        `Once upon a time there lived in a certain village a little country girl,
the prettiest creature that ever was seen. Her mother was very fond of
her, and her grandmother loved her still more. This good woman made
for her a little red riding-hood, which became the girl so well that
everybody called her Little Red Riding-hood.
One day her mother, having made some custards, said to her, "Go,
my dear, and see how your grandmother does, for I hear she has been
very ill; carry her a custard and this little pot of butter."
Little Red Riding-hood set out immediately to go to her
grandmother's, who lived in another village.
As she was going through the wood, she met Gaffer Wolf, who had a
very great mind to eat her up; but he dared not, because of some fagotmakers
hard by in the forest. He asked her whither she was going. The
poor child, who did not know that it was dangerous to stay and hear a
wolf talk, said to him, "I am going to see my grandmother, and carry her a
custard and a little pot of butter from my mamma."
"Does she live far off?" said the Wolf...`,

            },
            {
                title: '7. Enitity recognition',
                description: 'Find certain classes of words and their properties',
                rules:
                        `@how_many <- NUMBER
@when <- DATETIME
@where <- CITY.country == SE
`,
                text:
                        `News from last week: The benefits that come with owning a dog are clear-- physical activity, support, companionship -- but owning a dog could literally be saving your life.

Owners of hunting breeds, including terriers, retrievers, and scent hounds, were most protected from cardiovascular disease and death. However, owning any dog will reduce an owners risk of death, just to different extents, said Tove Fall, senior author of the study and Associate Professor in Epidemiology at Uppsala University.

The study looked at over 3.4 million Swedish individuals between the ages of 40 and 80 sampled from a national database and the Swedish Twin Register over a 12-year study period.`,

            },



        ];

        // fill examples
        const exampleSelect = $( "#loadExampleSelect" );
        exampleSelect.append($('<option value="" disabled selected>Examples...</option>'));
        examples.forEach((ex, ix) => {
            exampleSelect.append($("<option />").val(ix).text(ex.title));
        });

        // on option select
        function updateExample(){
            let example = examples[exampleSelect.val()];
            $('#scriptName').val(example.title)
            scriptEditor.setText(example.rules)
            $.hx.notify(example.description, 'primary', null, 15000);
            $('#textInput').val(example.text);
            $('#outputPanel').html('<i>Click [Run] to see the result...</i>');
            $('.nav-tabs a[href="#1"]').tab('show');
        }

        $('#loadExampleBtn').click(() => {
            updateExample()
            $('#loadExampleModal').modal('hide')
        });

        $('#newScriptBtn').click( function(){
                    scriptEditor.setText("")
                    setScriptName("New script")
                }
        )

        $('#downloadScriptBtn').click( e =>
                saveAs(new Blob([scriptEditor.getText()], {type: "text/plain;charset=utf-8"}), $('#scriptName').val()+".ccs")
        )

        $('#normalizeScriptBtn').click( e => {
            let formData = new FormData();
            formData.append("script", scriptEditor.getText());

            $.ajax({
                type: "POST",
                url: "/api/v1/script/normalize",
                data: formData,
                processData: false,
                contentType: false,
                success: (a) => {
                    scriptEditor.setText(a);

                }
            })
        })


        let openDocDialog = new OpenDocDialog('body', 'openCssModal', 'ccs', 'Open script', function (name, src) {
            scriptEditor.setText(src)
            setScriptName(name)
        } );

        let openVerionDocDialog = new OpenHistoryDocDialog('body', 'openVersionModal', 'ccs', function(){return openDocDialog.getOpenDocName()}, 'Open previous version', function (name, src) {
            scriptEditor.setText(src)
        } );

        let saveDocDialog = new SaveDocDialog('body', 'saveCssModal', 'ccs', 'Save script',
                function(){return scriptEditor.getText()},
                function(){return $('#scriptName').val()},
                function (name) {
                    setScriptName(name)
                    $.hx.notify('Script saved: ' + name, 'success')
                },
                function (name, e) {
                    const resp = JSON.parse(e.responseText);
                    if(resp.message) {
                        const message = resp.message;
                        let lineNr = resp.line - 1;

                        $.hx.notify('There is an error in your script.<br>' + resp.message, 'danger')
                        scriptEditor.setErrorMessage(lineNr, message)
                    } else {
                        $.hx.notify('The script could not be saved.<br>' + e, 'danger')
                    }
                }
        );

        setScriptName($.hx.get('scriptName', 'New script'))


        const sleaflet = new Sleaflet('map', 'pk.eyJ1IjoiYWhhbG1hIiwiYSI6ImNpeWp2dGMzbjAwMHIyd3I0dHV4bXE4dHUifQ.6e6CLc5hZdRItmVWkA_N3g',
                0, 0, 3);

        // const scriptEditor = new CcsEditor($('#scriptEditor')[0], 'stats.ccs');

        let convTable, msgTable, rangeTable;
        let colors =  ["#023fa5", "#7d87b9", "#bec1d4", "#d6bcc0", "#bb7784", "#8e063b", "#4a6fe3", "#8595e1", "#b5bbe3", "#e6afb9", "#e07b91", "#d33f6a", "#11c638", "#8dd593", "#c6dec7", "#ead3c6", "#f0b98d", "#ef9708", "#0fcfc0", "#9cded6", "#d5eae7", "#f3e1eb", "#f6c4e1", "#f79cd4"]

        function normalizeWord(w){
            w = w.toLowerCase();
            return w.replace(/[^\u0041-\u005A\u0061-\u007A\u00AA\u00B5\u00BA\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02C1\u02C6-\u02D1\u02E0-\u02E4\u02EC\u02EE\u0370-\u0374\u0376-\u0377\u037A-\u037D\u0386\u0388-\u038A\u038C\u038E-\u03A1\u03A3-\u03F5\u03F7-\u0481\u048A-\u0523\u0531-\u0556\u0559\u0561-\u0587\u05D0-\u05EA\u05F0-\u05F2\u0621-\u064A\u066E-\u066F\u0671-\u06D3\u06D5\u06E5-\u06E6\u06EE-\u06EF\u06FA-\u06FC\u06FF\u0710\u0712-\u072F\u074D-\u07A5\u07B1\u07CA-\u07EA\u07F4-\u07F5\u07FA\u0904-\u0939\u093D\u0950\u0958-\u0961\u0971-\u0972\u097B-\u097F\u0985-\u098C\u098F-\u0990\u0993-\u09A8\u09AA-\u09B0\u09B2\u09B6-\u09B9\u09BD\u09CE\u09DC-\u09DD\u09DF-\u09E1\u09F0-\u09F1\u0A05-\u0A0A\u0A0F-\u0A10\u0A13-\u0A28\u0A2A-\u0A30\u0A32-\u0A33\u0A35-\u0A36\u0A38-\u0A39\u0A59-\u0A5C\u0A5E\u0A72-\u0A74\u0A85-\u0A8D\u0A8F-\u0A91\u0A93-\u0AA8\u0AAA-\u0AB0\u0AB2-\u0AB3\u0AB5-\u0AB9\u0ABD\u0AD0\u0AE0-\u0AE1\u0B05-\u0B0C\u0B0F-\u0B10\u0B13-\u0B28\u0B2A-\u0B30\u0B32-\u0B33\u0B35-\u0B39\u0B3D\u0B5C-\u0B5D\u0B5F-\u0B61\u0B71\u0B83\u0B85-\u0B8A\u0B8E-\u0B90\u0B92-\u0B95\u0B99-\u0B9A\u0B9C\u0B9E-\u0B9F\u0BA3-\u0BA4\u0BA8-\u0BAA\u0BAE-\u0BB9\u0BD0\u0C05-\u0C0C\u0C0E-\u0C10\u0C12-\u0C28\u0C2A-\u0C33\u0C35-\u0C39\u0C3D\u0C58-\u0C59\u0C60-\u0C61\u0C85-\u0C8C\u0C8E-\u0C90\u0C92-\u0CA8\u0CAA-\u0CB3\u0CB5-\u0CB9\u0CBD\u0CDE\u0CE0-\u0CE1\u0D05-\u0D0C\u0D0E-\u0D10\u0D12-\u0D28\u0D2A-\u0D39\u0D3D\u0D60-\u0D61\u0D7A-\u0D7F\u0D85-\u0D96\u0D9A-\u0DB1\u0DB3-\u0DBB\u0DBD\u0DC0-\u0DC6\u0E01-\u0E30\u0E32-\u0E33\u0E40-\u0E46\u0E81-\u0E82\u0E84\u0E87-\u0E88\u0E8A\u0E8D\u0E94-\u0E97\u0E99-\u0E9F\u0EA1-\u0EA3\u0EA5\u0EA7\u0EAA-\u0EAB\u0EAD-\u0EB0\u0EB2-\u0EB3\u0EBD\u0EC0-\u0EC4\u0EC6\u0EDC-\u0EDD\u0F00\u0F40-\u0F47\u0F49-\u0F6C\u0F88-\u0F8B\u1000-\u102A\u103F\u1050-\u1055\u105A-\u105D\u1061\u1065-\u1066\u106E-\u1070\u1075-\u1081\u108E\u10A0-\u10C5\u10D0-\u10FA\u10FC\u1100-\u1159\u115F-\u11A2\u11A8-\u11F9\u1200-\u1248\u124A-\u124D\u1250-\u1256\u1258\u125A-\u125D\u1260-\u1288\u128A-\u128D\u1290-\u12B0\u12B2-\u12B5\u12B8-\u12BE\u12C0\u12C2-\u12C5\u12C8-\u12D6\u12D8-\u1310\u1312-\u1315\u1318-\u135A\u1380-\u138F\u13A0-\u13F4\u1401-\u166C\u166F-\u1676\u1681-\u169A\u16A0-\u16EA\u16EE-\u16F0\u1700-\u170C\u170E-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176C\u176E-\u1770\u1780-\u17B3\u17D7\u17DC\u1820-\u1877\u1880-\u18A8\u18AA\u1900-\u191C\u1950-\u196D\u1970-\u1974\u1980-\u19A9\u19C1-\u19C7\u1A00-\u1A16\u1B05-\u1B33\u1B45-\u1B4B\u1B83-\u1BA0\u1BAE-\u1BAF\u1C00-\u1C23\u1C4D-\u1C4F\u1C5A-\u1C7D\u1D00-\u1DBF\u1E00-\u1F15\u1F18-\u1F1D\u1F20-\u1F45\u1F48-\u1F4D\u1F50-\u1F57\u1F59\u1F5B\u1F5D\u1F5F-\u1F7D\u1F80-\u1FB4\u1FB6-\u1FBC\u1FBE\u1FC2-\u1FC4\u1FC6-\u1FCC\u1FD0-\u1FD3\u1FD6-\u1FDB\u1FE0-\u1FEC\u1FF2-\u1FF4\u1FF6-\u1FFC\u2071\u207F\u2090-\u2094\u2102\u2107\u210A-\u2113\u2115\u2119-\u211D\u2124\u2126\u2128\u212A-\u212D\u212F-\u2139\u213C-\u213F\u2145-\u2149\u214E\u2160-\u2188\u2C00-\u2C2E\u2C30-\u2C5E\u2C60-\u2C6F\u2C71-\u2C7D\u2C80-\u2CE4\u2D00-\u2D25\u2D30-\u2D65\u2D6F\u2D80-\u2D96\u2DA0-\u2DA6\u2DA8-\u2DAE\u2DB0-\u2DB6\u2DB8-\u2DBE\u2DC0-\u2DC6\u2DC8-\u2DCE\u2DD0-\u2DD6\u2DD8-\u2DDE\u2E2F\u3005-\u3007\u3021-\u3029\u3031-\u3035\u3038-\u303C\u3041-\u3096\u309D-\u309F\u30A1-\u30FA\u30FC-\u30FF\u3105-\u312D\u3131-\u318E\u31A0-\u31B7\u31F0-\u31FF\u3400\u4DB5\u4E00\u9FC3\uA000-\uA48C\uA500-\uA60C\uA610-\uA61F\uA62A-\uA62B\uA640-\uA65F\uA662-\uA66E\uA67F-\uA697\uA717-\uA71F\uA722-\uA788\uA78B-\uA78C\uA7FB-\uA801\uA803-\uA805\uA807-\uA80A\uA80C-\uA822\uA840-\uA873\uA882-\uA8B3\uA90A-\uA925\uA930-\uA946\uAA00-\uAA28\uAA40-\uAA42\uAA44-\uAA4B\uAC00\uD7A3\uF900-\uFA2D\uFA30-\uFA6A\uFA70-\uFAD9\uFB00-\uFB06\uFB13-\uFB17\uFB1D\uFB1F-\uFB28\uFB2A-\uFB36\uFB38-\uFB3C\uFB3E\uFB40-\uFB41\uFB43-\uFB44\uFB46-\uFBB1\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFB\uFE70-\uFE74\uFE76-\uFEFC\uFF21-\uFF3A\uFF41-\uFF5A\uFF66-\uFFBE\uFFC2-\uFFC7\uFFCA-\uFFCF\uFFD2-\uFFD7\uFFDA-\uFFDC\u4e00-\u9eff]/g, '').trim()

        }

        let all = undefined;

        function run(){
            scriptEditor.removeErrorMessage()

            const useScript = $('#toggleScriptBtn')[0].checked

            let formData = new FormData();
            if(useScript)
                formData.append("script", scriptEditor.getText());
            formData.append("channel", $.hx.get('channel', 'sample'));
            formData.append("from", $.hx.get('startDate').format());
            formData.append("to", $.hx.get('endDate').format());
            formData.append("labels", $('#labelSelect').val());
            sleaflet.clearMarkers()

            mApp.block("#scriptPortlet", {})
            $.ajax({
                type: "POST",
                url: "/api/v1/db/conversation/match" + (!useScript ? "/db" : ""),
                data: formData,
                processData: false,
                contentType: false,
                success: (analysis) => {
                    all = analysis
                    mApp.unblock("#scriptPortlet", {})
                    if (typeof analysis === 'undefined' || typeof analysis.labelHistogram === 'undefined' || typeof analysis.matchResults === 'undefined') {
                        $.hx.notify("An error occurred. Did you upload an Sample set?", 'danger');
                        return;
                    }

                    $('#labels').html('')

                    // update labelFilter from script
                    if(useScript && $('#labelSelect').val().length == 0)
                        updateLabelFilter()

                    // prepare colors
                    colors = Object.keys(analysis.labelHistogram).map($.hx.stringToColour)


                    let i = 0
                    for (const label of Object.keys(analysis.labelHistogram)) {
                        $('#labels').append('<a class="btn m-btn--pill btn-secondary btn-sm labelBtn" style="color:white;background-color:'+colors[i++]+'">'+label+'</a>')
                    }

                    $('.labelBtn').click(function(){
                        let label = $(this).text()
                        updateWordHistogram(analysis.wordHistograms[label])
                    })

                    loadHistogram(analysis.labelHistogram);
                    // loadMessages(analysis.matchResults);
                    updateConversationTable(analysis.matchResults)
                    updateMap(analysis.matchResults);
                    updateTimeline(analysis.timeLines);

                    $.hx.scrollIntoView('#legendPortlet', -85);
                },
                error: (e) => {
                    mApp.unblock("#scriptPortlet", {})
                    if(typeof e === 'undefined' || typeof e.responseText === 'undefined') {
                        $.bootstrapGrowl("An error occurred", 'danger');
                    } else {
                        e = JSON.parse(e.responseText);
                        let message = e.message;
                        let lineNr = e.line - 1;
                        if (lineNr !== undefined) {
                            scriptEditor.setErrorMessage(lineNr, message)
                        }
                    }
                }
//        contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
            });
        };
        $('#runBtn').click(run);

        function updateConversationTable(matchResults) {
            if (convTable ) {
                convTable.destroy()
                convTable = undefined
                // $('#convDataTableParent').html('<div id="convDataTable"></div>');
            }
            if (msgTable ) {
                msgTable.destroy()
                msgTable = undefined
                // $('#msgDataTableParent').html('<div id="msgDataTable"></div>');
            }
            if (rangeTable ) {
                rangeTable.destroy()
                // $('#labelDataTableParent').html('<div id="labelDataTable"></div>');
                $('#convhighlight').html('')

            }
            convTable = $('#convDataTable').mDatatable({
                // datasource definition
                data: {
                    type: 'local',
                    source: matchResults,
                    pageSize: 10
                },

                // layout definition
                layout: {
                    theme: 'default', // datatable theme
                    scroll: true, // enable/disable datatable scroll both horizontal and vertical when needed.
                    // height: 430, // datatable's body's fixed height
                    footer: false // display/hide footer
                },

                toolbar: {
                    layout: ['pagination', 'info'],
                    placement: ['bottom'],  //'top', 'bottom'
                    items: {
                        pagination: {
                            type: 'default',

                            pages: {
                                desktop: {
                                    layout: 'default',
                                    pagesNumber: 6
                                },
                                tablet: {
                                    layout: 'default',
                                    pagesNumber: 3
                                },
                                mobile: {
                                    layout: 'compact'
                                }
                            },

                            navigation: {
                                prev: true,
                                next: true,
                                first: true,
                                last: true
                            },

                            pageSizeSelect: [5, 10, 50, -1]
                        },

                        info: true
                    }
                },

                // column sorting
                sortable: true,
                pagination: true,

                search: {
                    input: $('#convSearchInput'),
                    delay: 200,
                },
                // inline and bactch editing(cooming soon)
                // editable: false,

                // columns definition
                columns: [
                    {field: "id", title: " ", width: 40, sortable: false, template: function (row, index, datatable) {
                            // return '<a class="conversationDetailBtn">' + row.id + '</a>'
                            return '<div class="conversationDetailBtn btn btn-primary m-btn m-btn--icon m-btn--icon-only m-btn--pill"\
                                           data-conv-id="'+row.conversation.id+'">\
                                        <i class="la la-comments"></i>\
                                        </div>'
                        }},
                    {field: "from", title: "time", width: 400, template: function (row, index, datatable) {
                            const messages = row.conversation.messages;
                            const t1 = moment(messages[0].timestamp);
                            const t2 = moment(messages[messages.length-1].timestamp);
                            // return t1.format("YYYY-MM-DD") + ' <span style="color: #ccc">(' + t1.format("HH:mm") + ')</span> - ' +
                            //         t2.format("YYYY-MM-DD") + ' <span style="color: #ccc">(' + t2.format("HH:mm") + ')</span>, ' + t2.fromNow()

                            const duration = moment.duration(t2.diff(t1)).humanize();
                            return t1.format("YYYY-MM-DD") + ' <span style="color: #ccc">(' + t1.format("HH:mm") + ')</span> , ' +
                                    duration + ', ' + t2.fromNow()

                        }},
                    {field: "userid", title: "user", template: row => row.conversation.userId},
                    {field: "labels", title: "labels", template: function (row, index, datatable) {
                            const labels = Object.keys(row.matches)
                            return !labels ? '-' : labels.map(label => {
                                const color = $.hx.stringToColour(label);
                                return '<div style="color: white;text-shadow: 0 1px 2px black;padding:2px 5px; margin: 1px; border-radius:5px;display: inline-block;background: '+color+' ">'+label+'</div>'}).join(' ')
                        }},
                    {field: "channel", title: "channel", template: row => row.conversation.channel},
                    {
                        field: "Actions",
                        width: 60,
                        title: "Actions",
                        sortable: false,
                        overflow: 'visible',
                        template: function (row, index, datatable) {
                            const dropup = (datatable.getPageSize() - index) <= 4 ? 'dropup' : '';
                            return '<div class="dropdown '+ dropup+'">\
                                  <a href="#" class="btn m-btn m-btn--hover-error m-btn--icon m-btn--icon-only m-btn--pill" data-toggle="dropdown">\
                                      <i class="la la-ellipsis-h"></i>\
                                  </a>\
                                    <div class="dropdown-menu dropdown-menu-right">\
                                      <a class="deleteConvBtn dropdown-item m--font-danger" data-conv-id="'+ row.conversation.id+'"><i class="la la-trash"></i> Delete </a>\
                                    </div>\
                              </div>';
                        }
                    }
                ]
            });
            $('#convDataTable')
                    .on('click', `.conversationDetailBtn`, function () {
                        const convId = $(this).data('conv-id');
                        updateMessageTable(convId)
                        $.hx.scrollIntoView('#msgPortlet', -85);
                    })
                    .on('click', `.deleteConvBtn`, function () {
                        const convId = $(this).data('conv-id');
                        $.ajax({
                            url: '/api/v1/db/conversation/' + encodeURIComponent(convId),
                            type: 'DELETE',
                            success: function(result) {
                                $.hx.notify('Conversation deleted.', 'success')
                                update()
                            }
                        });

                    })
        }

        function updateMap(matchResults){

            $('#map').show()
            let locationCount = 0;
            for (let result of matchResults) {
                const ranges = [].concat.apply([], Object.values(result.matches)) // flatten
                ranges.forEach(range => {
                    if(range.props.latitude){
                        // found a location
                        locationCount++;
                        // sleaflet.addCircle(range.props.latitude * 1, range.props.longitude * 1, 1000, 'rgb(11, 98, 164)', result.highlight, 0.25, true)
                        sleaflet.addMarker(range.props.latitude * 1, range.props.longitude * 1, result.highlight, true)
                    }
                })
            }
            if(locationCount) {
                $('#map').show()
                $('#noLocationMsg').hide()
                sleaflet.addCluster()
                sleaflet.zoomToMarkers()
            } else {
                $('#map').hide()
                $('#noLocationMsg').show()

            }

        }

        function updateWordHistogram(wordHistogram){
            $('#valueHistogram').html('');
            $.hx.barplot('#valueHistogram', Object.keys(wordHistogram), Object.values(wordHistogram), undefined, '#cc6')

        }

        function updateTimeline(timeLines){
            const layout = {
                // title: 'Label timeline',
                autosize: true,
                showlegend: true,
                legend: {"orientation": "h"},
                margin: {
                    t: 0,
                    l: 30,
                    r: 10,
                    pad: 4
                }
                // paper_bgcolor: '#7f7f7f',
                // plot_bgcolor: '#c7c7c7'
            };
            let traces = [];
            let i = 0;
            for (let [label, tvs] of Object.entries(timeLines)) {
                let data  = {x:[], y:[], type:'scatter', name:label, line: {color: colors[i]}, marker:{color: colors[i]}};
                i++
                tvs.forEach(tv => {
                    data.x.push(tv.t.substring(0, 19).replace('T', ' '));
                    data.y.push(tv.value);
                });
                traces.push(data);
            }
            $('#timeline').html('');
            $.hx.fluidplot('#timeline', traces, layout);
        }

        let loadHistogram = function(data) {
            $('#labelHistogram').html('');
            $('#valueHistogram').html('');

            let emptyLayout = {
                xaxis: {
                    autorange: true,
                    showgrid: false,
                    zeroline: false,
                    showline: false,
                    autotick: true,
                    ticks: '',
                    showticklabels: false
                },
                yaxis: {
                    autorange: true,
                    showgrid: false,
                    zeroline: false,
                    showline: false,
                    autotick: true,
                    ticks: '',
                    showticklabels: false
                }
            };

            let gd = $.hx.barplot('#labelHistogram', Object.keys(data), Object.values(data), undefined, colors);

            $.hx.barplot('#valueHistogram', [], [], undefined, colors, emptyLayout);

            gd.on('plotly_click', function(data){
                let label = data.points[0].x
                updateWordHistogram(all.wordHistograms[label])
            })
        };


        let updateMessageTable = function (convId) {

            if (msgTable ) {
                msgTable.destroy()
                msgTable = undefined
                // $('#msgDataTableParent').html('<div id="msgDataTable"></div>');
            }

            $('#msgHighlight').html('')
            const highlight = all.matchResults.find(mr => mr.conversation.id === convId).highlight;
            $('#msgHighlight').html(highlight)

            const analysisResult = all.matchResults.filter(mr => mr.conversation.id === convId)[0]

            if(!analysisResult)
                return

            msgTable = $('#msgDataTable').mDatatable({
                // datasource definition
                data: {
                    type: 'local',
                    source: analysisResult.conversation.messages,
                    pageSize: 10
                },

                // layout definition
                layout: {

                    theme: 'default', // datatable theme
                    scroll: true, // enable/disable datatable scroll both horizontal and vertical when needed.
                    // height: 430, // datatable's body's fixed height
                    footer: false // display/hide footer
                },

                toolbar: {
                    layout: ['pagination', 'info'],
                    placement: ['bottom'],  //'top', 'bottom'
                    items: {
                        pagination: {
                            type: 'default',

                            pages: {
                                desktop: {
                                    layout: 'default',
                                    pagesNumber: 6
                                },
                                tablet: {
                                    layout: 'default',
                                    pagesNumber: 3
                                },
                                mobile: {
                                    layout: 'compact'
                                }
                            },

                            navigation: {
                                prev: true,
                                next: true,
                                first: true,
                                last: true
                            },

                            pageSizeSelect: [5, 10, 50, -1]
                        },

                        info: true
                    }
                },

                // column sorting
                sortable: false,
                pagination: true,

                search: {
                    input: $('#msgSearchInput'),
                    delay: 200,
                },
                // inline and bactch editing(cooming soon)
                // editable: false,

                // columns definition
                columns: [
                    /*{field: "id", title: "conversation", template: function (row, index, datatable) {
                            return '<span class="conversationDetailBtn">' + row.id + '</span>'
                        }},*/
                    {field: "timestamp", title: "time", template: function (row, index, datatable) {
                            const m = moment(row.timestamp);
                            const timeStr = '<i class="la la-history"></i> ' + m.format("YYYY-MM-DD") + ' <span style="color: #ccc">(' + m.format("HH:mm:ss") + ')</span>, ' + m.fromNow()
                            const userStr = '<i class="la la-user"></i> ' + row.sender
                            return timeStr + '<br/>' + userStr
                        }},
                    // {field: "senderId", title: "from"},
                    {field: "text", title: "message", template: function (row, index, datatable) {
                            return row.incoming ?
                                    '<div style="padding: 1em; border-radius: 8px;color: #000;text-align:left;background:#f2f3f8">' + row.text + '</div>' :
                                    '<div style="padding: 1em; border-radius: 8px;color: #fff;text-align:right;background: #716aca">' + row.text + '</div>'
                        }},

                ]
            });




            //$this, username, text, imagepath, inOrOut
            // _.forEach(messages, function(message) {
            //     chatbox.addMessage(chatbox, message.sender, message.text, "/assets/global/images/you.png", "in", true);
            // });


        }


        // export data
        let settings = {
            data: [[]],
            fixedRowsTop: 1,
            stretchH: 'last',
            autoWrapRow: true,
            rowHeaders: true,
            colHeaders: true,
            contextMenu: true,
            manualRowMove: true,
            manualColumnResize: true,
            search: true,
            sortIndicator: true,
            columnSorting: true,
        };
        const hot = new Handsontable(document.getElementById('handsontable'), settings);

        const searchField = document.getElementById('searchInput')
        Handsontable.dom.addEvent(searchField, 'keyup', function (event) {
            let search = hot.getPlugin('search');
            let queryResult = search.query(this.value);
            if(queryResult.length) {
                $('#searchCount').text(queryResult.length)
                hot.scrollViewportTo(queryResult[0].row, queryResult[0].col)
            } else {
                $('#searchCount').text('')
                hot.scrollViewportTo(0, 0)
            }

            hot.render();
        });

        hot.addHook('afterSelectionEnd', function(r, c, r2, c2) {
            const convId = hot.getDataAtRow(r)[0];
            updateMessageTable(convId);
        })


        $('#downloadSheet').click(() => {
            $.hx.csvDownload( hot.getData(), '\t', 'conversation-export.csv')
        })

        $('#exportDataBtn').click(function(){
            const useScript = $('#toggleScriptBtn')[0].checked
            $('#exportDataRow').show();
            $.get('/api/v1/db/conversation/extract',
                    {
                        script:  useScript ? scriptEditor.getText() : null,
                        channel:  $.hx.get('channel', 'sample'),
                        from: $.hx.get('startDate').format(),
                        to: $.hx.get('endDate').format(),
                        labels:  $('#colSelect').val().join(','),
                    }, function(csv){
                        hot.loadData($.hx.csvParse(csv));
                    }
            )
        })
    })

</script>

</#macro>