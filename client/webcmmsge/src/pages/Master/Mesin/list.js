import React from 'react';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

/// import axios 
import axios from '../../../utils/server';

/// command for exporting data to excel
let gridApi;
const onGridReady = (params) => {
    gridApi = params.api
}
const onExportClick = () => {
    gridApi.exportDataAsCsv()
}
/// button export action
const actionButton = (params) => { console.log(params) }

class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            /// state for data mesin
            dataMesin: [],
            loading: true,
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "No. Mesin",
                    field: 'nomesin',
                },
                {
                    headerName: "Keterangan",
                    field: 'keterangan',
                },
                {
                    headerName: "Site",
                    field: 'site',
                },
                // {
                //     headerName: 'Action',
                //     editable: false,
                //     sortable: false,
                //     filter: false,
                //     floatingFilter: false,
                //     field: 'idmesin',
                //     cellRenderer: (params) => <div><button type='button' className='btn btn-success' onClick={() => actionButton(params.data.idmesin)}>Ubah</button></div>
                // }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: true,
                sortable: true,
                flex: 1,
                minWidth: 100,
                filter: true,
                floatingFilter: true,
                resizable: true,
            },
            gridOptions: {
                pagination: true,
                paginationAutoPageSize: true,
                enableFilter: true,
                enableSorting: true
            }
        }
    }
    /// init state
    async componentDidMount() {
        await this.getDataMesin()
    }

    /// getting data mesin from api
    async getDataMesin() {
        this.setState({ loading: true })
        axios.get("mesin/0", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            console.log(response.data.data);
            this.setState({ dataMesin: response.data.data })
            // console.log('??', this.state.dataMesin)
        }).catch((error) => {
            console.log(error)
            alert(error.response.message)
        }).finally(() => {
            this.setState({ loading: false })
        })
    }

    render() {
        return (
            <div>
                {/* /// load navigation */}
                <NavbarComponent />
                {/* /// Name form and export button */}
                <div className='container-fluid'>
                    <h1>Data Mesin</h1>
                    <button className='btn btn-primary' onClick={() => onExportClick()}>Export</button>
                </div>
                {/* /// table data grid */}
                <div className='ag-theme-alpine' style={{ height: '100vh', width: '100vw' }}>
                    <AgGridReact
                        suppressExcelExport={true}
                        rowData={this.state.dataMesin}
                        columnDefs={this.state.columnDefs}
                        onGridReady={onGridReady}
                        animateRows={true}
                        gridOptions={this.state.gridOptions}
                        defaultColDef={this.state.defaultColDef}
                        loadingCellRendererParams={this.state.loadingCellRendererParams}
                    />
                </div>
            </div>
        );
    }
}

export default List;
